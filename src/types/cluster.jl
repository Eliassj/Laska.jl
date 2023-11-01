####################################################
#
# Cluster is meant to hold 1 cluster as well as all
# info such as depth, fr and computed values such as MAD anc cv2.
#
####################################################


struct Cluster{T<:Real}
    id::Int64
    info::Dict{String,String}
    spiketimes::Vector{T}
end


"""

    id(cluster::Cluster)

Returns the id of `cluster`
"""
@inline function id(cluster::Cluster)
    return cluster.id
end


"""

    info(cluster::Cluster)

Returns info (as dict) about `cluster`. A string may be supplied to return a specific entry (as Float64).
"""
@inline function info(cluster::Cluster)
    return cluster.info
end

@inline function info(cluster::Cluster, var::String)
    return cluster.info[var]
end


"""
    
    spiketimes(cluster::Cluster)

Returns the spiketimes of `cluster`.
"""
@inline function spiketimes(cluster::Cluster)
    return cluster.spiketimes
end
