


function maxval(vec::Vector{Vector{T}}) where {T<:Real}
    max::T = 0
    for n in eachindex(vec)
        for i in eachindex(vec[n])
            if vec[n][i] > max
                max = vec[n][i]
            end
        end
    end
    return max
end


function minval(vec::Vector{Vector{T}}) where {T<:Real}
    min::T = 0
    for n in eachindex(vec)
        for i in eachindex(vec[n])
            if vec[n][i] < min
                min = vec[n][i]
            end
        end
    end
    return min
end
