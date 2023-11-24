# Functions for summarizing clusters

function spikedict(p::Laska.PhyOutput)
    return Dict{Int64,Vector{Int64}}(c => p._spiketimes[p._spiketimes[:, 1].==c, 2] for c in p._info[!, "cluster_id"])
end

"""
Calculate the number of spikes for each cluster/period(ms)

Returns a 3-column matrix with cluster, time, n-spikes.

"""
function spikesper(p::Laska.PhyOutput, period::Int64)
    period::Int64 = Int64(period * parse(Float64, p._meta["imSampRate"]) / 1000)

    timesum = deepcopy(p._spiketimes)
    @simd for t in 1:length(timesum[:, 1])
        timesum[t, 2] = floor(timesum[t, 2] / period) * period
    end

    ex = extrema(timesum[:, 2])
    resmatrix::Matrix{Int64} = Matrix{Int64}(undef, (Int(length(p._info[!, "cluster_id"]) * length(ex[1]:period:ex[2])), 3))
    n::Int = 1
    times = ex[1]:period:ex[2]
    for c in getclusters(p)
        @simd for t in eachindex(times)
            @inbounds resmatrix[n, :] = [c times[t] 0]
            n += 1
        end
    end

    findhash::Vector{UInt64} = hash.(resmatrix[:, 1], hash.(resmatrix[:, 2]))
    indlookup = Dict(findhash[n] => n for n in eachindex(findhash))
    hashiter = hash.(timesum[:, 1], hash.(timesum[:, 2]))

    @inline incrres!(resmatrix, indlookup, hashiter, 3)

    return resmatrix
end

# 2|ISIn+1 − ISIn|/(ISIn+1 + ISIn)
function cv2(p::PhyOutput, updateinfo::Bool=false)
    begin
        isis = spikeisi(p)
        cv = isis[:, 2]
        cv = 2 .* abs.(circshift(cv, 1) .- cv) ./ (circshift(cv, 1) .+ cv)
        ind = circshift(isis[:, 1], 1) - isis[:, 1]
        cv = cv[ind.==0, :]
        out = hcat(isis[ind.==0, 1], cv)
    end

    if updateinfo == true
        clusters = getclusters(p)
        means = Vector{Float64}(undef, length(clusters))
        medians = Vector{Float64}(undef, length(clusters))
        for (n, c) in enumerate(clusters)
            means[n] = DataFrames.Statistics.mean(out[out[:, 1].==c, 2])
            medians[n] = DataFrames.Statistics.median(out[out[:, 1].==c, 2])

        end
        insertcols!(p._info, "cv2mean" => means)
        insertcols!(p._info, "cv2median" => medians)
    end

    return out
end

# median absolute difference from the median interspike interval (MAD)
function mad(p::PhyOutput)
    isis = spikeisi(p)
    isis = Float64.(isis)
    clusters = getclusters(p)
    result = Matrix{Float64}(undef, (length(clusters), 2))
    for (n, c) in enumerate(clusters)

        result[n, :] = [c, DataFrames.Statistics.median(abs.(isis[isis[:, 1].==c, 2] .- DataFrames.Statistics.median(isis[isis[:, 1].==c, 2])))]
    end
    return result
end

function mad!(p::PhyOutput)
    isis = spikeisi(p)
    isis = Float64.(isis)
    clusters = getclusters(p)
    result = Matrix{Float64}(undef, (length(clusters), 2))
    for (n, c) in enumerate(clusters)
        result[n, :] = [c, DataFrames.Statistics.median(abs.(isis[isis[:, 1].==c, 2] .- DataFrames.Statistics.median(isis[isis[:, 1].==c, 2])))]
    end
    insertcols!(p._info, "mad" => result[:, 2])

    return result
end

function medianisi!(p::PhyOutput)
    out = Vector{Float64}(undef, length(getclusters(p)))
    isis = spikeisi(p)
    for (n, c) in enumerate(getclusters(p))
        out[n] = StatsBase.Statistics.median(isis[isis[:, 1].==c, 2])
    end
    insertcols!(p._info, "median_isi" => out)
end

# Max amplitude of response
# TODO: Add guard against "false" max/min response amp?
"""
Get the max/minimum relative response (change in frequency) after a stimulation.            
Stimulation is specified by a string matching one in 't._stimulations', standard response window is 50ms, standard period when calculating relative response is 5ms.

"""
function responseAMP(t::relativeSpikes, stimulation::String; timewindow::Int64=50, period::Int64=5)
    rel = relresponse(t, period, clusterbaseline(t))
    filt = findall(x -> t._stimulations[stimulation] * 30.0 < x < (t._stimulations[stimulation] + timewindow) * 30.0, rel[:, 2])
    rel = rel[filt, :]
    clusters = Float64.(getclusters(t))
    indices = indlookup(rel, clusters)
    out::Matrix{Float64} = Matrix(undef, length(clusters), 3)
    out[:, 1] = clusters
    @inbounds for (n, v) in enumerate(rel[:, 3])
        rel[n, 3] = v - 1
    end
    @inbounds for (n, c) in enumerate(out[:, 1])
        mx = findmax(maximum, abs.(rel[indices[c], 3]))[2]
        out[n, 2:3] = rel[indices[c], 2:3][mx, :]
    end
    return out
end

function responseduration(t::relativeSpikes, stimulation::String, tol::Float64, period::Int64=25)
    rel = relresponse(t, period, clusterbaseline(t))
    rel = rel[findall(x -> x > t._stimulations[stimulation] * 30, rel[:, 2]), :]
    rel = rel[findall(x -> 1.0 - tol < x < 1.0 + tol, rel[:, 3]), :]

    return rel
end

function _convolveresponse(invec::Vector{Float64}, kernel_len::Int64)
    kernel = fill(1 / kernel_len, kernel_len)
    return conv(invec, kernel)
end

"""
Returns a dict containing clusters => stability value.

Stability is calculated as number of `periods` that fall within the median number of spikes/period +/- median number of spikes * 'mdfactor'
"""
function stability(p::PhyOutput; mdfactor::Float64=0.2, period::Int64=1000)
    per = spikesper(p, period)
    out = Dict{Int64,Float64}()
    for c in getclusters(p)
        #fr = filter(:cluster_id => x -> x == c, p._info)[!, "fr"][1]
        @inbounds v = @view(per[per[:, 1].==c, 3])
        md = median(v)

        out[c] = length(v[md-md*mdfactor.<v.<md+md*mdfactor]) / length(v)
    end
    return out
end
