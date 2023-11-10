


"""
    normalize(vec::Vector{Float64}, min::Real = 0, max::Real = 1)

Returns a min-max normalized version of `vec`. Defaults to 0-1 but custom ranges can be specified.

See [`normalize!`](@ref) for an in-place version
"""
function normalize(vec::Vector{<:Real}, min::T, max::T) where {T<:Real}
    x::Vector{Float64} = deepcopy(vec)
    minx = minimum(x)
    diffx = maximum(x) - minx
    rangediff = max - min

    for v in eachindex(x)
        x[v] = min + ((x[v] - minx) * rangediff) / diffx
    end
    return x
end

function normalize(vec::Vector{<:Real})
    x::Vector{Float64} = deepcopy(vec)
    minx = minimum(x)
    diffx = maximum(x) - minx
    for v in eachindex(x)
        x[v] = ((x[v] - minx)) / diffx
    end
    return x
end



"""
    normalize!(vec::Vector{<:AbstractFloat}, min::Real, max::Real)

Normalize an `AbstractFloat` vector in place.

See [`normalize`](@ref) for a version that works on non-Float vectors.
"""
function normalize!(vec::Vector{<:AbstractFloat})
    minx = minimum(vec)
    diffx = maximum(vec) - minx
    for v in eachindex(vec)
        vec[v] = ((vec[v] - minx)) / diffx
    end
end

function normalize!(vec::Vector{<:AbstractFloat}, min::T, max::T) where {T<:Real}
    minx = minimum(vec)
    diffx = maximum(vec) - minx
    rangediff = max - min
    for v in eachindex(vec)
        vec[v] = min + ((vec[v] - minx) * rangediff) / diffx
    end
end

