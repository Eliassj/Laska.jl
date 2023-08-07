# Data transformations

struct relativeSpikes
    _spiketimes::Dict{}
    _info::DataFrames.DataFrame
    _meta::Dict{SubString{String}, SubString{String}}
    _binpath::String
    _stimulations::Union{Dict, Nothing}
    _specs::Dict

    function relativeSpikes(p::Laska.PhyOutput, back::Int64 = 500, forward::Int64 = 600; context::Dict = Dict())
        spikes = filtertriggers(p, back, forward)
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


function filtertriggers(p::Laska.PhyOutput, back::Int64, forward::Int64)
    if typeof(p._triggers) == Nothing
        ArgumentError("PhyOutput does not contain triggers")
    end
    
    back = back * parse(Float64, p._meta["imSampRate"]) / 1000
    forward = forward * parse(Float64, p._meta["imSampRate"]) / 1000
    triggers = Array{Int64}(undef, (0,3))
    vec = p._spiketimes[:,2]

    tmp = Vector{Bool}(undef, length(vec))
    it::UnitRange{Int64} = 1:length(vec)
    for (n, trig) in enumerate(p._triggers)
        rang = Set((trig - back):(trig+forward))
        ind = filterrange(vec, rang, tmp, it)
        filt = p._spiketimes[ind,:]
        res = hcat(filt, fill(n, size(filt,1)))
        res[:,2] = res[:,2] .- trig
        triggers = vcat(triggers, res)
    end
    return triggers
end


function filterrange(a::Vector{Int64}, rs::Set, tmp::Vector{Bool}, it::UnitRange{Int64})
    Threads.@threads for n in it
        @inbounds tmp[n] = a[n] in rs
    end
    return findall(x -> x == true, tmp)
end

function clusterbaseline(t::relativeSpikes)
    clusters = Set(t._spiketimes[:,1])
    tim = t._len[1] / 1000
    ind = t._spiketimes[findall(x -> x < 0, t._spiketimes[:, 2]), :]
    clusterbaselines = Dict()
    for c in clusters
        tmp = zeros(t._stimulations["ntrig"], 1)
        data = ind[findall(x -> x == c, ind[:, 1]), :]
        Threads.@threads for n in 1:t._stimulations["ntrig"]
            @inbounds tmp[n] = length(filter(t -> t == n, data[:, 3])) / tim
        end
        clusterbaselines[c] = tmp
    end
    return clusterbaselines
end

function spikeisi(p::Laska.PhyOutput)
    d::Dict{Int64, Vector{Int64}} = Dict(c => Vector{Int64}() for c in p._info[!, "cluster_id"])
    Threads.@threads for c in p._info[!, "cluster_id"]
        @inbounds tmp::Vector{Int64} = p._spiketimes[p._spiketimes[:,1] .== c, 2]
        for i in 1:length(tmp)-1
            @inbounds tmp[i] = tmp[i+1] - tmp[i]
        end
        @inbounds d[c] = tmp[1:end-1]
    end

    #if updateinfo == true
    #    means = Vector{Float64}(undef, length(p._info[!, "cluster_id"]))
    #    for (n, c) in enumerate(p._info[!, "cluster_id"])
    #        means[n] = sum(d[c]) / length(d[c])
    #    end
    #    medians = Vector{Float64}(undef, length(p._info[!, "cluster_id"]))
    #    for (n, c) in enumerate(p._info[!, "cluster_id"])
    #        len = length(d[c])
    #        sorted = sort(d[c])
    #        if len % 2 == 0
    #            medians[n] = (sorted[Int(len/2)] + sorted[Int((len/2)+1)]) / 2
    #        else
    #            medians[n] = sorted[Int((len/2)+0.5)]
    #        end
    #    end
    #    insertcols!(p._info, "ISImean" => means, "ISImedian" => medians)
    #end
    return d
end