##################################
#
# Functions relating to clustering
#
##################################



fnormal(x, μ, σ) = exp((-(x - μ)^2) / ((2*σ)^2)) / σ * sqrt(2*pi)

function normalvector(len, σ, max = 1)
    v = collect(0:len)
    v = fnormal.(v, maximum(v) / 2, σ)
    v = v .* max / maximum(v)
end



function makeway(A)
    waymatrix = similar(convolved)
    waymatrix[:,end] .= convolved[:,end]
    for j in 2:size(waymatrix)[2] - 1
        for i in 2:(size(waymatrix)[1]-1)
            waymatrix[i,end-j] = convolved[i,end-j] + minimum(waymatrix[(i-1):(i+1), end - (j - 1)])
        end
    end
    waymatrix[1,:] .= maximum(waymatrix)
    waymatrix[end, :] .= maximum(waymatrix)
    return waymatrix
end



function findway(start, waymatrix)
    resvec = Vector{Int64}(undef, size(waymatrix)[2])
    resvec[1] = start
    for j in 2:length(resvec)
        start = start + findall(t->t .== minimum(waymatrix[(start-1):(start+1), j]), waymatrix[(start-1):(start+1), j])[1] - 2
        resvec[j] = start
    end
    return resvec
end


function clustergraph(p::PhyOutput, edgevariables::Tuple{String})
    edges::Matrix{Int64} = Matrix{Int64}(undef, nclusters(p)^2, 2)
    n = 1
    for (c1, c2) in Iterators.product(getclusters(p), getclusters(p))
        edges[n,:] = [c1, c2]
        n += 1
    end
    return edges
end