######################
#
# Data transformations
#
######################

# TODO Change function naming in accordance with style guide
struct relativeSpikes
    _spiketimes::Matrix{Int64}
    _info::DataFrames.DataFrame
    _meta::Dict{SubString{String},SubString{String}}
    _binpath::String
    _stimulations::Union{Dict,Nothing}
    _specs::Dict{String,Int64}

    function relativeSpikes(p::Laska.PhyOutput, context::Dict=Dict(); back::Int=500, forward::Int=600)
        spikes = filtertriggers(p, Float64(back), Float64(forward))
        ntrig = maximum(spikes[:, 3])
        specs::Dict{String,Int64} = Dict(
            "back" => back,
            "forward" => forward,
            "ntrig" => ntrig
        )
        new(
            spikes,
            p._info,
            p._meta,
            p._binpath,
            context,
            specs
        )
    end
end


function filtertriggers(p::PhyOutput, back::Float64, forward::Float64)
    res = Matrix{Int64}(undef, (size(p._spiketimes)[1], 3))

    backF::Float64 = back * parse(Float64, p._meta["imSampRate"]) / 1000
    forwardF::Float64 = forward * parse(Float64, p._meta["imSampRate"]) / 1000

    pos::Int64 = 1
    for (n, trig) in enumerate(p._triggers)
        tmp::Matrix{Int64} = p._spiketimes[trig-backF.<=p._spiketimes[:, 2].<=trig+forwardF, :]
        tmp = hcat(tmp, fill(n, size(tmp, 1)))
        tmp[:, 2] = tmp[:, 2] .- (trig)
        res[pos:(size(tmp)[1]+pos-1), :] = tmp
        pos += size(tmp)[1]
    end
    return res[1:pos-1, :]
end



function clusterbaseline(t::relativeSpikes)
    clusters::Vector{Int64} = t._info[!, "cluster_id"]
    tim::Float64 = t._specs["back"] / 1000
    ind::Matrix{Int64} = t._spiketimes[findall(x -> x < 0, t._spiketimes[:, 2]), :]
    clusterbaselines = Dict{Int64,Matrix{Float64}}()
    for c::Int64 in clusters
        tmp::Matrix{Float64} = zeros(t._specs["ntrig"], 1)
        data = ind[findall(x -> x == c, ind[:, 1]), :]
        Threads.@threads for n::Int64 in 1:t._specs["ntrig"]
            @inbounds tmp[n] = length(filter(t -> t == n, data[:, 3])) / tim
        end
        clusterbaselines[Int64(c)] = tmp
    end
    return ClusterBaseline(clusterbaselines)
end

function depthbaseline(t::relativeSpikes)
    depths::Set{Float64} = Set(t._info[!, "depth"]::Vector{Float64})
    ind::Matrix{Int64} = t._spiketimes[t._spiketimes[:, 2].<0, :]
    tim::Float64 = t._specs["back"] / 1000
    depthbaselines = Dict{Int64,Matrix{Float64}}()
    for d::Float64 in depths
        tmp = zeros(t._specs["ntrig"], 1)
        clusters::Set{Int64} = Set{Int64}(subset(t._info, :depth => ByRow(x -> x == d))[!, "cluster_id"]::Vector{Int64})
        data::Matrix{Int64} = ind[findall(x -> x in clusters, ind[:, 1]), :]
        Threads.@threads for n in 1:t._specs["ntrig"]
            @inbounds tmp[n] = length(filter(t -> t == n, data[:, 3])) / tim
        end
        depthbaselines[Int64(d)] = tmp
    end
    return DepthBaseline(depthbaselines)
end

@inline function getbaseline(key::Int64, baseline::ClusterBaseline)
    return baseline.x[key]
end

@inline function getbaseline(key::Int64, baseline::DepthBaseline)
    return baseline.x[key]
end

function spikesper(t::relativeSpikes, period::Int64=30)
    cperiod::Int64 = Int64(period * parse(Float64, t._meta["imSampRate"]) / 1000)

    timesum = deepcopy(t._spiketimes)
    timesum[:, 2] = floor.(timesum[:, 2] ./ cperiod) .* cperiod
    ex = extrema(timesum[:, 2])
    ns = Iterators.product(t._info[!, "cluster_id"], collect(ex[1]:cperiod:ex[2]), collect(1:t._specs["ntrig"]))

    resmatrix::Matrix{Int64} = Matrix{Int64}(undef, (length(t._info[!, "cluster_id"]) * length(ex[1]:cperiod:ex[2]) * length(1:t._specs["ntrig"]), 4))
    n::Int64 = 1
    for (c, time, trig) in ns
        resmatrix[n, :] = [c time trig 0]
        n += 1
    end
    hashlib::Matrix{UInt64} = hcat(hash.(resmatrix[:, 1], hash.(resmatrix[:, 2], hash.(resmatrix[:, 3]))), zeros(UInt64, size(resmatrix)[1]))
    lookhash = hash.(timesum[:, 1], hash.(timesum[:, 2], hash.(timesum[:, 3])))
    indlookup = Dict(hashlib[n, 1] => n for n in eachindex(hashlib[:, 1]))

    incrres!(resmatrix, indlookup, lookhash, 4)
    return resmatrix[sortperm(resmatrix[:, 1]), :]
end


"""

r = Results-matrix where counts are stored.           
ind = Dict in the format hash => row index of r where rows in cols to index by result in the same hash.             
v = Vector of hashes, each corresponding to a row in r and an entry in ind, to iterate over.            
col = Which col to store results in.

"""
function incrres!(r::Matrix{Int64}, ind::Dict{UInt64,Int64}, v::Vector{UInt64}, col::Int)
    for i in v
        r[ind[i], col] += 1
    end
end


# TODO Separate into 1 function for single bins and 1 for summarizing by cluster/depth/triggertime
# ie by cluster & every n:th trigger

"""
Compute the relative response compared to a baseline (currently only by cluster.)

Returns: A 'Matrix{Float64}' wit 3 columns: cluster, time(30kHz), relative response

"""
function relresponse(t::relativeSpikes, period::Int64, baseline::ClusterBaseline)
    absolutes::Matrix{Int64} = spikesper(t, period)
    re::Matrix{Float64} = Float64.(absolutes)

    for i in 1:size(absolutes)[1]
        re[i, 4] = absolutes[i, 4] * (1000 / period) / baseline.x[absolutes[i, 1]][absolutes[i, 3]]
    end
    re = re[sortperm(re[:, 1]), :]

    mm::Matrix{Float64} = Matrix(undef, Int(nclusters(t) * length(unique(re[:, 2]))), 3)


    d::Dict{UInt64,Vector{Float64}} = Dict(hash(re[n, 1], hash(re[n, 2])) => Vector{Float64}() for n in 1:size(re)[1])

    _filteredpush!(d, re)

    n = 1
    for c in getclusters(t)
        for time in unique(re[:, 2])
            mm[n, :] = [c, time, DataFrames.Statistics.mean(d[hash(c, hash(time))])]
            n += 1
        end
    end
    return mm
end


function relresponse(t::relativeSpikes, period::Int64, baseline::DepthBaseline)
    absolutes::Matrix{Int64} = spikesper(t, period)
    period::Int64 = period * 30
    times::Vector{Float64} = minimum(absolutes[:, 2]):period:maximum(absolutes[:, 2])
    out::Matrix{Float64} = Matrix(undef, length(times) * length(getdepths(t)), 3)
    hashacc::Dict{UInt64,Float64} = Dict{UInt64,Float64}()
    depthdict::Dict{Int64,Float64} = Dict{Int64,Float64}(
        cluster => filter(:cluster_id => x -> x == cluster, t._info)[!, "depth"][1] for cluster in getclusters(t)
    )

    n::Int64 = 0
    for d::Float64 in getdepths(t)
        for t in times
            n += 1
            hashacc[hash(d, hash(t))] = 0.0
            out[n, 1:2] = [d t]
        end
    end
    for row in 1:size(absolutes, 1)
        hashacc[hash(depthdict[absolutes[row, 1]], hash(Float64(absolutes[row, 2])))] += absolutes[row, 4] * 30000 / period
    end


    for nrow in 1:size(out, 1)
        out[nrow, 3] = hashacc[hash(out[nrow, 1], hash(out[nrow, 2]))] / (mean(baseline.x[Int64(out[nrow, 1])]) * 340)
    end

    out = out[sortperm(out[:, 2]), :]

    return out
end


# relresponse with depthdiv
# TODO: FIXA SÅ ALLA DJUP/KLUSTER ANVÄNDER INDIVIDUELLA BASELINES!!!
function relresponse(t::relativeSpikes, period::Int64, baseline::DepthBaseline, depthdiv::Int64)
    absolutes::Matrix{Int64} = spikesper(t, period)
    period::Int64 = period * 30
    times::Vector{Float64} = minimum(absolutes[:, 2]):period:maximum(absolutes[:, 2])
    out::Matrix{Float64} = Matrix(undef, length(times) * depthdiv, 3)
    depthinterval::Float64 = ceil(maximum(getdepths(t)) / depthdiv)
    depths::Vector{Float64} = [i * depthinterval for i in 1:depthdiv]
    hashacc::Dict{UInt64,Float64} = Dict{UInt64,Float64}()
    depthdict::Dict{Int64,Float64} = Dict{Int64,Float64}(
        cluster => filter(:cluster_id => x -> x == cluster, t._info)[!, "depth"][1] for cluster in getclusters(t)
    )
    # Create mean baselines for each depth interval
    #    adjustedbaseline::Dict{Float64,Float64} = Dict{Float64,Float64}(depth => 0.0 for depth in depths)
    #    all::Vector{Float64} = getdepths(t)
    #    n_depths::Dict{Float64,Int64} = Dict{Float64,Int64}()
    #    for d in depths # Iterate over depth intervals
    #        current::Vector{Float64} = all[(d-depthinterval).<all.<=d]
    #        n_depths[d] = length(current)
    #        for spec in current # Iterate over individual depths
    #            adjustedbaseline[d] += mean(baseline.x[spec])
    #        end
    #        adjustedbaseline[d] /= n_depths[d]
    #    end
    n::Int64 = 0
    for d::Float64 in depths
        for t in times
            n += 1
            hashacc[hash(d, hash(t))] = 0.0
            out[n, 1:2] = [d t]
        end
    end
    for row in 1:size(absolutes, 1)
        hashacc[hash(depthdict[absolutes[row, 1]], hash(Float64(absolutes[row, 2])))] += absolutes[row, 4] * 30000 / (period * baseline.x[depthdict[absolutes[row, 1]]][absolutes[row, 3]])
    end


    for nrow in 1:size(out, 1)
        out[nrow, 3] = hashacc[hash(out[nrow, 1], hash(out[nrow, 2]))]
    end

    out = out[sortperm(out[:, 2]), :]

    return out
end

"""
    _filteredpush!(in::Matrix{Float64}, dic::Dict{UInt64, Float64})

Push values from column 4 of `in` into `dic` whose keys are hashes of column 1 & 2 in `in`.     
NaN:s and Inf:s are filtered.        
Currently ONLY for use in `relresponse`!
"""
function _filteredpush!(dic::Dict{UInt64,Vector{Float64}}, in::Matrix{Float64})
    for n in 1:size(in)[1]
        if !isnan(in[n, 4]) && !isinf(in[n, 4])
            push!(dic[hash(in[n, 1], hash(in[n, 2]))], in[n, 4])
        end
    end
    return dic
end

# Optimera genom att använda n_spikes från info?
function spikeisi(p::Laska.PhyOutput)
    shifted::Matrix{Int64} = circshift(p._spiketimes, -1) - p._spiketimes
    newclstrs::Vector{Int64} = p._spiketimes[shifted[:, 1].==0, 1]
    shifted = shifted[shifted[:, 1].==0, :]
    out::Matrix{Int64} = hcat(newclstrs, shifted[:, 2])
    return out
end

function autocorrelogram(p::PhyOutput, cluster::Int64, binsize::Int64)
    times::Vector{Int64} = getspiketimes(p, cluster)[:, 2]
    @assert binsize >= 1 "binsize should be >= 1"
    restmp = Vector{Int64}(undef, length(times))
    count = Accumulator{Int64,Int64}()
    for n in eachindex(times)
        restmp = fld.(times .- times[n], binsize)
        for i in restmp
            count[i] += 1
        end
    end
    return count
end

function autocorrelogramfft(p::PhyOutput, cluster::Int64, binsize::Int64)
    times::Vector{Int64} = extendvecthin(getspiketimes(p, cluster)[:, 2])
    #timescorr::Vector{Float64} = times .- mean(times)
    f = FFTW.fft(times)
    f = real.(f) .* conj.(f)
    out::Vector{Complex} = ifft(f)

    return out
end

