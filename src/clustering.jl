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



function makeway(A::Matrix)
    waymatrix = similar(A)
    waymatrix[:,end] .= A[:,end]
    for j in 2:size(waymatrix)[2] - 1
        for i in 2:(size(waymatrix)[1]-1)
            waymatrix[i,end-j] = A[i,end-j] + minimum(waymatrix[(i-1):(i+1), end - (j - 1)])
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

