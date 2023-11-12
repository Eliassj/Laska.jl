


"""
    normalize(vec::Vector{Float64}, min::Real = 0, max::Real = 1)

Returns a min-max normalized version of `vec`. Defaults to 0-1 but custom ranges can be specified.

See [`normalize!`](@ref) for an in-place version
"""
function normalize(vec::Vector{<:Real})
    out::Vector{Float64} = deepcopy(vec)
    normalize!(out)
    return out
end

function normalize(vec::Vector{<:Real}, min::T, max::T) where {T<:Real}
    out::Vector{Float64} = deepcopy(vec)
    normalize!(out, min, max)
    return out
end

function normalize(vec::Vector{<:Real}, min::T, max::T, minmax::NTuple{2,T}) where {T<:Real}
    out::Vector{Float64} = deepcopy(vec)
    normalize!(out, min, max, minmax)
    return out
end

function normalize(vec::Vector{<:Real}, minmax::NTuple{2,T}) where {T<:Real}
    out::Vector{Float64} = deepcopy(vec)
    normalize!(out, minmax)
    return out
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

function normalize!(vec::Vector{<:AbstractFloat}, min::T, max::T, minmax::NTuple{2,T}) where {T<:Real}
    minx = minmax[1]
    diffx = minmax[2] - minmax[1]
    rangediff = max - min
    for v in eachindex(vec)
        vec[v] = min + ((vec[v] - minx) * rangediff) / diffx
    end
end

function normalize!(vec::Vector{<:AbstractFloat}, minmax::NTuple{2,T}) where {T<:Real}
    diffx = minmax[2] - minmax[1]
    for v in eachindex(vec)
        vec[v] = ((vec[v] - minmax[1])) / diffx
    end
end




