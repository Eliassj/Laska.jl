###########################################################
# 
# Container(s) for all Clusters that are part of an experiment
#
###########################################################

mutable struct PhyOutput{T<:Real} <: AbstractExperiment
    cellids::Vector{Int64}
    clusters::Vector{Cluster{T}}
    trigtimes::Vector{T}
    meta::Dict{SubString{String},SubString{String}}

end

struct RelativeSpikes{T<:Real} <: AbstractExperiment
    cellids::Vector{Int64}
    clusters::Vector{RelativeCluster{T}}
    trigtimes::Vector{T}
    meta::Dict{SubString{String},SubString{String}}
    stimtrain::Dict{String,T}
    specs::Dict{String,T}
end


@inline function getcell(experiment::T, cell::Int64) where {T<:AbstractExperiment}
    return experiment.clusters[findfirst(x -> x == cell, experiment.cellids)]
end

@inline function ntrigs(experiment::T) where {T<:AbstractExperiment}
    return length(experiment.trigtimes)
end

@inline function whichcells(experiment::T) where {T<:AbstractExperiment}
    return experiment.cellids
end


@inline function triggertimes(experiment::T) where {T<:AbstractExperiment}
    return experiment.trigtimes
end


@inline function clustervector(experiment::T) where {T<:AbstractExperiment}
    return experiment.clusters
end

@inline function getmeta(experiment::T, entry::String) where {T<:AbstractExperiment}
    return experiment.meta[entry]
end

@inline function getmeta(experiment::T) where {T<:AbstractExperiment}
    return experiment.meta
end

# RelativeSpikes- 
