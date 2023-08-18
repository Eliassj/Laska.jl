##################################
#
# Functions relating to clustering
#
##################################


num1 = [rand(1:450) for i in 1:20]
num2 = [rand(550:1000) for i in 1:20]


test2 = zeros(
    Float64,
    1000,
    1000
    )

test2[num1, num2] .= 1
test2[num2, num1] .= 1

test2

fnormal(x, μ, σ) = exp((-(x - μ)^2) / ((2*σ)^2)) / σ * sqrt(2*pi)

function normalvector(len, σ, max = 1)
    v = collect(0:len)
    v = fnormal.(v, maximum(v) / 2, σ)
    v = v .* max / maximum(v)
end

lines(normalvector(100, 15, 1))

convolved = conv(normalvector(100, 15, 1), normalvector(100, 15, 1), test2)
heatmap(convolved)

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

way = makeway(convolved)
starts = [sum(way[:,k]) for k in 1:size(way)[2]]

function findway(start, waymatrix)
    resvec = Vector{Int64}(undef, size(waymatrix)[2])
    resvec[1] = start
    for j in 2:length(resvec)
        start = start + findall(t->t .== minimum(waymatrix[(start-1):(start+1), j]), waymatrix[(start-1):(start+1), j])[1] - 2
        resvec[j] = start
    end
    return resvec
end
w = Vector{Vector{Int64}}(undef, 55)
max = maximum(way)
for (k,i) in enumerate(10:20:1090)
    w[k] = findway(i, way)
    for j in 1:size(way)[2]
        way[w[k][j], j] = max
    end
end

for k in 1:55
    
end
w[1]
way[500, 1]
heatmap(way)