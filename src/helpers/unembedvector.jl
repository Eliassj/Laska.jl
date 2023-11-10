#########################################################################################
#
# Turn a Vector of Vectors into a single Vector containing all elements of the "embedded"
# Vectors
#
##########################################################################################

function unembedvector(vec::Vector{Vector{T}}) where {T}
    out::Vector{Int64} = Vector{Int64}(undef, 0)
    for v in vec
        out = vcat(out, v)
    end
    return out
end
