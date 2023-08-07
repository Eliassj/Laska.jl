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