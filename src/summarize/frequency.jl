######################################
#
# Calculate the frequency of a Cluster
#
######################################

"""

    frequency(cluster::Cluster, period::T) where {T<:Real}

Returns a Vector containing the frequency of the cluster in the form of spikes/period binned at each multiple of `period`.            
Spiketimes are binned to the next *largest* multiple of `period`. Ie a spike happening at time = 30001 will be in the 60000 bin.

# Example

For a cluster sampled at 30 000Hz...
```julia
Laska.frequency(cluster, 30000)
```
...will return spikes/second.

Indexing into the result as:        
```julia
result[n]
```
Will return the n:th bin which describes the number of spikes occuring between `period * n` and `period * n-1`.


"""
function frequency(cluster::Cluster, period::T) where {T<:Real}
    times = spiketimes(cluster)
    return frequency(times, period)
end

function frequency(cluster::RelativeCluster{N}, period::T) where {T<:Real,N<:Real}
    times::Vector{Vector{N}} = spiketimes(cluster)
    vec::Vector{N} = unpackvector(times)

    return frequency(vec, period)
end

# frequency of relative spikes by depth
function frequency(exp::RelativeSpikes{T}, depths::Int64, period::T) where {T<:Real}
    alldepths::Vector{Float64} = parse.(Float64, info.(clustervector(exp), "depth"))

    maxdepth::Float64 = maximum(alldepths)
    depthinterval = maxdepth / depths

    actualdepths::Vector{Int64} = Int64[]

    # Determine what depths to include
    for d in depths:-1:1
        if length(alldepths[(d-1)*depthinterval.<=alldepths.<d*depthinterval]) != 0
            push!(actualdepths, d)
        end
    end


    nbacktime = mstosamplerate(exp, relativespecs(exp, "back")) / period

    backbins::Int64 = floor(nbacktime)

    lins = Vector{Vector{Float64}}(undef, 0)
    for i in actualdepths
        times::Vector{Float64} = frequency(unpackvector(spikesatdepth(exp, ((i - 1) * depthinterval, i * depthinterval))), period)
        normalize!(times, (0.0, mean(times[1:backbins])))
        push!(lins, times[2:end])
    end
    return lins
end


function frequency(times::Vector{T}, period::T) where {T<:Real}

    # NOTE: Should the binning be different? Use Laska.arbitraryround instead?
    accumulator::Dict{T,Int64} = Dict{T,Int64}(t => 0 for t in roundup(minimum(times), period):period:roundup(maximum(times), period))

    @inbounds for n in eachindex(times)
        accumulator[roundup(times[n], period)] += 1
    end

    sorter = sortperm(collect(keys(accumulator)))

    return collect(values(accumulator))[sorter]
end


