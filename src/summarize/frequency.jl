######################################
#
# Calculate the frequency of a Cluster
#
######################################

"""

    frequency(cluster::Cluster, period::T) where {T<:Real}

Returns the frequency of the cluster in the form of spikes/period.


"""
function frequency(cluster::Cluster, period::T) where {T<:Real}
    times = spiketimes(cluster)

    # NOTE: Range of accumulator starts at `period` as time = 0 will always have no spikes due to
    # rounding up. Change if rounding function is changed!
    accumulator::Dict{T,Int64} = Dict{T,Int64}(t => 0 for t in period:period:roundup(maximum(times), period))

    @inbounds for n in eachindex(times)
        accumulator[roundup(times[n], period)] += 1
    end

    sorter = sortperm(collect(keys(accumulator)))

    return collect(values(accumulator))[sorter]
end

