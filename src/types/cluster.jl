####################################################
#
# Cluster is meant to hold 1 cluster as well as all
# info such as depth, fr and computed values such as MAD anc cv2.
#
####################################################

struct Cluster{T<:Real} <: AbstractCluster
    id::Int64
    info::Dict{String,String}
    spiketimes::Vector{T}
end


"""

    id(cluster::Cluster)

Returns the id of `cluster`
"""
@inline function id(cluster::T) where {T<:AbstractCluster}
    return cluster.id
end


"""

    info(cluster::Cluster)

Returns info (as dict) about `cluster`. A string may be supplied to return a specific entry (as Float64).
"""
@inline function info(cluster::T) where {T<:AbstractCluster}
    return cluster.info
end

@inline function info(cluster::T, var::String) where {T<:AbstractCluster}
    return cluster.info[var]
end


"""
    
    spiketimes(cluster::Cluster)

Returns the spiketimes of `cluster`.

"""
@inline function spiketimes(cluster::T) where {T<:AbstractCluster}
    return cluster.spiketimes
end


"""
Struct for holding a cluster and its spiketimes relative to triggers.       
Similar to `Cluster{T}` except that the field `spiketimes` is a `Vector{Vector{T}}` where each vector represents trigger #n.


"""
struct RelativeCluster{T<:Real} <: AbstractCluster
    id::Int64
    info::Dict{String,String}
    spiketimes::Vector{Vector{T}}
end
