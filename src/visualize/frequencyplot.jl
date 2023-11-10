

function depthfrequency(p::PhyOutput{T}, depthdiv::Int64) where {T<:Real}
    maxdepth = maximum(parse.(Float64, info.(clustervector(p), "depth")))
    depthinterval = maxdepth / depthdiv
end
