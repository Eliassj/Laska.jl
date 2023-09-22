# Functions for summarizing clusters

function spikedict(p::Laska.PhyOutput)
    return Dict{Int64, Vector{Int64}}(c => p._spiketimes[p._spiketimes[:,1] .== c,2] for c in p._info[!,"cluster_id"])
end


function spikesper(p::Laska.PhyOutput, period::Float64 = 10.0)
    period = period * parse(Float64, p._meta["imSampRate"]) / 1000
    t = Matrix{Int64}(undef, size(p._spiketimes))
    t[:,1] = p._spiketimes[:,1]
    t[:,2] = Int.(ceil.(p._spiketimes[:,2] ./ period) .* period)
    #tmp::Matrix{Int64} = zeros(Int64, Int(maximum(t[:,2])/300)+1, 3)
    noll::Vector{Int64} = zeros(Int64, Int(maximum(t[:,2])/period)+1)
    tmp = Vector{Int64}(collect(0:period:Int(maximum(t[:,2]))))
    out = collect(Iterators.product(p._info[!,"cluster_id"], collect(0:period:Int(maximum(t[:,2])))))
    out = Matrix{Int64}(undef, Int((maximum(t[:,2])/period)+1)*size(p._info)[1], 3)
    out[:,2] = repeat(tmp, Int(size(out)[1] / length(tmp)))
    pos = 1
    for c in p._info["cluster_id"]
        for time in tmp
            
        end
    end
end

# 2|ISIn+1 − ISIn|/(ISIn+1 + ISIn)
function cv2(p::PhyOutput, updateinfo::Bool = false)
    begin
    isis = spikeisi(p)
    cv = isis[:,2]
    cv = 2 .* abs.(circshift(cv, 1) .- cv) ./ (circshift(cv, 1) .+ cv)
    ind = circshift(isis[:,1], 1) - isis[:,1]
    cv = cv[ind .== 0,:]
    out = hcat(isis[ind .== 0,1], cv)
    end
    
    if updateinfo == true
        clusters = getclusters(p)
        means = Vector{Float64}(undef, length(clusters))
        medians = Vector{Float64}(undef, length(clusters))
        for (n, c) in enumerate(clusters)
            means[n] = DataFrames.Statistics.mean(out[out[:,1] .== c, 2])
            medians[n] = DataFrames.Statistics.median(out[out[:,1] .== c, 2])

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

        result[n,:] = [c, DataFrames.Statistics.median(abs.(isis[isis[:,1] .== c, 2] .- DataFrames.Statistics.median(isis[isis[:,1] .== c, 2])))]
    end
    return result
end

function mad!(p::PhyOutput)
    isis = spikeisi(p)
    isis = Float64.(isis)
    clusters = getclusters(p)
    result = Matrix{Float64}(undef, (length(clusters), 2))
    for (n, c) in enumerate(clusters)
        result[n,:] = [c, DataFrames.Statistics.median(abs.(isis[isis[:,1] .== c, 2] .- DataFrames.Statistics.median(isis[isis[:,1] .== c, 2])))]
    end
    insertcols!(p._info, "mad" => result[:,2])
    
    return result
end

function medianisi!(p::PhyOutput)
    out = Vector{Float64}(undef, length(getclusters(p)))
    isis = spikeisi(p)
    for (n,c) in enumerate(getclusters(p))
        out[n] = StatsBase.Statistics.median(isis[isis[:,1] .== c, 2])
    end
    insertcols!(p._info, "median_isi" => out)
end

# Amplitude of response, add delay to max response and duration of response(?)
function responseAMP(t::relativeSpikes, timewindow::Int64 = 50, period::Int64 = 5)
    rel = relresponse(t, period, clusterbaseline(t))
    filt = findall(x -> t._stimulations["US"] * 30.0 < x <  (t._stimulations["US"] + timewindow) * 30.0, rel[:,2])
    rel = rel[filt,:]
    clusters = Float64.(getclusters(t))
    out::Matrix{Float64} = Matrix(undef, length(clusters), 2)
    out[:,1] = clusters
    for (n,c) in enumerate(out[:,1])
        out[n, 2] = maximum(abs.(rel[rel[:,1] .== c,3] .- 1))
    end
    return ou t
end
