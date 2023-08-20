# Data transformations


# TODO Change function naming in accordance with style guide
struct relativeSpikes
    _spiketimes::Matrix{Int64}
    _info::DataFrames.DataFrame
    _meta::Dict{SubString{String}, SubString{String}}
    _binpath::String
    _stimulations::Union{Dict, Nothing}
    _specs::Dict

    function relativeSpikes(p::Laska.PhyOutput, back::Int = 500, forward::Int = 600; context::Dict = Dict())
        spikes = filtertriggers(p, Float64(back), Float64(forward))
        ntrig = maximum(spikes[:,3])
        specs = Dict(
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
        tmp::Matrix{Int64} = p._spiketimes[trig - backF .<= p._spiketimes[:,2] .<= trig + forwardF, :]
        tmp = hcat(tmp, fill(n, size(tmp,1)))
        tmp[:,2] = tmp[:,2] .- (trig)
        res[pos:(size(tmp)[1]+pos-1),:] = tmp
        pos += size(tmp)[1]
    end
    return res[1:pos-1,:]
end



function clusterbaseline(t::relativeSpikes)
    clusters = t._info[!,"cluster_id"]
    tim = t._specs["back"] / 1000
    ind = t._spiketimes[findall(x -> x < 0, t._spiketimes[:, 2]), :]
    clusterbaselines = Dict{Int64, Matrix{Float64}}()
    for c in clusters
        tmp = zeros(t._specs["ntrig"], 1)
        data = ind[findall(x -> x == c, ind[:, 1]), :]
        Threads.@threads for n in 1:t._specs["ntrig"]
            @inbounds tmp[n] = length(filter(t -> t == n, data[:, 3])) / tim
        end
        clusterbaselines[Int64(c)] = tmp
    end
    return ClusterBaseline(clusterbaselines)
end

function depthbaseline(t::relativeSpikes)
    depths = Set(t._info[!, "depth"])
    ind = t._spiketimes[t._spiketimes[:,2] .< 0,:]
    tim = t._specs["back"] / 1000
    depthbaselines = Dict{Int64, Matrix{Float64}}()
    for d in depths
        tmp = zeros(t._specs["ntrig"], 1)
        clusters = Set(subset(t._info, :depth => ByRow(x -> x == d))[!, "cluster_id"])
        data = ind[findall(x -> x in clusters, ind[:,1]), :]
        Threads.@threads for n in 1:t._specs["ntrig"]
            @inbounds tmp[n] = length(filter(t -> t == n, data[:,3])) / tim
        end
        depthbaselines[Int64(d)] = tmp
    end
    return DepthBaseline(depthbaselines)
end

function spikesper(t::relativeSpikes, period::Int64 = 30)
    cperiod::Int64 = Int64(period * parse(Float64, t._meta["imSampRate"]) / 1000)

    timesum = deepcopy(t._spiketimes)
    timesum[:,2] = floor.(timesum[:,2] ./ cperiod) .* cperiod
    ex = extrema(timesum[:,2])
    ns = Iterators.product(t._info[!,"cluster_id"], collect(ex[1]:cperiod:ex[2]), collect(1:t._specs["ntrig"]))

    resmatrix::Matrix{Int64} = Matrix{Int64}(undef, (length(t._info[!, "cluster_id"]) * length(ex[1]:cperiod:ex[2]) * length(1:t._specs["ntrig"]), 4))
    n::Int64 = 1
    for (c, time, trig) in ns
        resmatrix[n,:] = [c time trig 0]
        n += 1
    end
    hashlib::Matrix{UInt64} = hcat(hash.(resmatrix[:,1], hash.(resmatrix[:,2], hash.(resmatrix[:,3]))), zeros(UInt64, size(resmatrix)[1]))
    lookhash = hash.(timesum[:,1], hash.(timesum[:,2], hash.(timesum[:,3])))
    indlookup = Dict(hashlib[n,1] => n for n in eachindex(hashlib[:,1]))

    incrres!(resmatrix, indlookup, lookhash)
    return resmatrix[sortperm(resmatrix[:,1]),:]
end

function incrres!(r::Matrix{Int64}, ind::Dict{UInt64, Int64}, v::Vector{UInt64})
    for i in v
        @inbounds r[ind[i], 4] += 1
    end
end


# TODO Separate into 1 function for single bins and 1 for summarizing by cluster/depth/triggertime
# ie by cluster & every n:th trigger
function relresponse(t::relativeSpikes, period::Int64, baseline::ClusterBaseline)
    absolutes::Matrix{Int64} = spikesper(t, period)
    re::Matrix{Float64} = Float64.(absolutes)

    for i in 1:size(absolutes)[1]
        re[i, 4] = absolutes[i, 4] * (1000 / period) / baseline.x[absolutes[i, 1]][absolutes[i, 3]]
    end
    re = re[sortperm(re[:,1]),:]

    mm::Matrix{Float64} = Matrix(undef, Int(nclusters(t) * length(unique(re[:,2]))), 3)
    

    d::Dict{UInt64, Vector{Float64}} = Dict(hash(re[n,1], hash(re[n,2])) => Vector{Float64}() for n in 1:size(re)[1])

    _filteredpush!(d, re)

    n=1
    for c in getclusters(t)
            for time in unique(re[:,2])
                mm[n,:] = [c, time, DataFrames.Statistics.mean(d[hash(c, hash(time))])]
                n += 1
            end
    end
    return mm
end

"""
    _filteredpush!(in::Matrix{Float64}, dic::Dict{UInt64, Float64})

Push values from column 4 of `in` into `dic` whose keys are hashes of column 1 & 2 in `in`.     
NaN:s and Inf:s are filtered.        
Currently ONLY for use in `relresponse`!
"""
function _filteredpush!(dic::Dict{UInt64, Vector{Float64}}, in::Matrix{Float64})
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
    newclstrs::Vector{Int64} = p._spiketimes[shifted[:,1] .== 0, 1]
    shifted = shifted[shifted[:,1] .== 0,:]
    out::Matrix{Int64} = hcat(newclstrs, shifted[:,2])
    return out
end

function autocorrelogram(p::PhyOutput, cluster::Int64, binsize::Int64)
    times::Vector{Int64} = getspiketimes(p, cluster)[:,2]
    @assert binsize >= 1 "binsize should be >= 1"
    restmp = Vector{Int64}(undef, length(times))
    count = Accumulator{Int64, Int64}()
    for n in eachindex(times)
        restmp = fld.(times .- times[n], binsize)
        for i in restmp
            count[i] += 1
        end
    end
    return count
end

function autocorrelogramfft(p::PhyOutput, cluster::Int64, binsize::Int64)
    times::Vector{Int64} = extendvecthin(getspiketimes(p, cluster)[:,2])
    #timescorr::Vector{Float64} = times .- mean(times)
    f = FFTW.fft(times)
    f = real.(f) .* conj.(f)
    out::Vector{Complex} = ifft(f)
    
    return out
end
