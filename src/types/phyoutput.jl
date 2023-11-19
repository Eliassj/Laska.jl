###########################################################
# 
# Container(s) for all Clusters that are part of an experiment
#
###########################################################

mutable struct PhyOutput{T} <: AbstractExperiment{T}
    cellids::Vector{Int64}
    clusters::Vector{Cluster{T}}
    trigtimes::Vector{T}
    meta::Dict{SubString{String},SubString{String}}

end

struct RelativeSpikes{T} <: AbstractExperiment{T}
    cellids::Vector{Int64}
    clusters::Vector{RelativeCluster{T}}
    trigtimes::Vector{T}
    meta::Dict{SubString{String},SubString{String}}
    stimtrain::Dict{String,T}
    specs::Dict{String,T}
end


"""

    function getcluster(experiment::T, cluster::Int64) where {T<:AbstractExperiment}

Returns a `cluster` from `experiment`.

"""
function getcluster(experiment::T, cluster::Int64) where {T<:AbstractExperiment}
    return experiment.clusters[findfirst(x -> x == cluster, experiment.cellids)]
end


"""

function ntrigs(experiment::T) where {T<:AbstractExperiment}

Returns the number of trigger events in `experiment`.
"""
function ntrigs(experiment::T) where {T<:AbstractExperiment}
    return length(experiment.trigtimes)
end

"""

    function clusterids(experiment::T) where {T<:AbstractExperiment}

Returns a Vector of all cluster id:s present in experiment.

"""
function clusterids(experiment::T) where {T<:AbstractExperiment}
    return experiment.cellids
end

"""

    triggertimes(experiment::T) where {T<:AbstractExperiment}

Returns the timestamps of trigger events in `experiment`.

"""
function triggertimes(experiment::T) where {T<:AbstractExperiment}
    return experiment.trigtimes
end

"""

clustervector(experiment::T) where {T<:AbstractExperiment}

Returns a `Vector{T}` where T<:AbstractCluster containing all clusters in `experiment`.

"""
function clustervector(experiment::T) where {T<:AbstractExperiment}
    return experiment.clusters
end


"""
getmeta(experiment::T, entry::String) where {T<:AbstractExperiment}
getmeta(experiment::T) where {T<:AbstractExperiment}

Returns experiment meta info from spikeGLX. If an `entry` string is not supplied all entries are returned.

"""
function getmeta(experiment::T, entry::String) where {T<:AbstractExperiment}
    return experiment.meta[entry]
end

function getmeta(experiment::T) where {T<:AbstractExperiment}
    return experiment.meta
end

# RelativeSpikes- 
"""
    relativespecs(rel::RelativeSpikes{T}) 
    relativespecs(rel::RelativeSpikes{T}, spec::String) where {T<:Real}


Returns a Dict containing the 'specs' of a `RelativeSpikes` struct.                         
Includes the `back` and `forward` variables used as well as the number of trigger events (`ntrigs`).
"""
function relativespecs(rel::RelativeSpikes{T}) where {T<:Real}
    return rel.specs
end


function relativespecs(rel::RelativeSpikes{T}, spec::String) where {T<:Real}
    return rel.specs[spec]
end

"""

    stimtimes(experiment::RelativeSpikes)

Returns a dict containing the stimtrain of a `RelativeSpikes` struct in the form of `label => time`.
"""
function stimtimes(experiment::RelativeSpikes)
    return experiment.stimtrain
end
