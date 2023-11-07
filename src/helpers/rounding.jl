###############
#
# Round up/down
#
###############

"""

    roundup(value::T, interval::N) where T<:Real where N<:Real

Rounds a value up to an interval.


"""
function roundup(value::T, interval::N) where {T<:Real} where {N<:Real}
    return N(ceil(value / interval) * interval)
end


function rounddown(value::T, interval::N) where {T<:Real} where {N<:Real}
    return N(floor(value / interval) * interval)
end

function roundupvec(in::Vector{N}, period::T) where {T<:Real} where {N<:Real}
    out = Vector{T}(undef, length(in))
    roundupvec!(out, in, period)
    return out
end

function roundupvec!(out::Vector{T}, in::Vector{N}, period::T) where {N<:Real} where {T<:Real}
    @inbounds for n in eachindex(out)
        out[n] = roundup(in[n], period)
    end
end

function rounddownvec(in::Vector{N}, period::T) where {T<:Real} where {N<:Real}
    out = Vector{T}(undef, length(in))
    rounddownvec!(out, in, period)
    return out
end

function rounddownvec!(out::Vector{T}, in::Vector{N}, period::T) where {N<:Real} where {T<:Real}
    @inbounds for n in eachindex(out)
        out[n] = rounddown(in[n], period)
    end
end
