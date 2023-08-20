using Laska
using TSne
using Statistics
using GLMakie
using DSP
using CairoMakie



ffr = :fr => x -> x > 1

@time res = Laska.PhyOutput(
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24",
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0",
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\.laska\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0.bin",
    filters = (ffr,)
)

@time tes = Laska.relativeSpikes(res, context = Dict("US" => 0, "CS" => 300))


data = Laska.getchan(res, 375:385, 0, 0.3, true, true)

Laska.plotchannelsinteractive(res, 375:385, 0, 0.1)

Laska.GLMakie.activate!()
Laska.plotraster(tes, 158)

s = Scene()


# t-sne
Laska.mad!(res)
Laska.cv2(res, true)

mat = Matrix(Laska.DataFrames.select(res._info, :depth, :cv2median, :mad))


for c in 1:size(mat)[2]
    mat[:,c] = mat[:,c] ./ maximum(mat[:,c])
end


Tsne = tsne(mat, 2, 0, 1000, 5)
return Tsne
CairoMakie.text(
    Tsne[:,1],
    Tsne[:,2],
    text = string.(res._info[!, "cluster_id"])
)



tres=tsn()

GLMakie.text(
    tres[:,1],
    tres[:,2],
    text = string.(res._info[!, "cluster_id"])
)

function tmatrix(tsneres::Matrix{Float64})
    for i in eachindex(tsneres)
        tsneres[i] = round((tsneres[i] - minimum(tsneres)) * 1) + 1
    end
    clen = Int(round(maximum(tsneres[:,1]) * 1))
    rlen = Int(round(maximum(tsneres[:,2]) * 1))
    matr = zeros(Float64, rlen, clen)

    for i in 1:size(tsneres)[1]
        matr[Int(tsneres[i,2]), Int(tsneres[i, 1])] = 1
    end

    return matr
end

bigmatr = tmatrix(Tsne)

heatmap(bigmatr)

fnormal(x, μ, σ) = exp((-(x - μ)^2) / ((2*σ)^2)) / σ * sqrt(2*pi)

function normalvector(len, σ, max = 1)
    v = collect(0:len)
    v = fnormal.(v, maximum(v) / 2, σ)
    v = v .* max / maximum(v)
end

convolved = conv(normalvector(50, 10, 10), normalvector(50, 10, 10), bigmatr)

heatmap(convolved)

way=similar(convolved)
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

waymatrix = makeway(convolved)

heatmap(waymatrix)

function findway(start, waymatrix)
    resvec = Vector{Int64}(undef, size(waymatrix)[2])
    resvec[1] = start
    for j in 2:length(resvec)
        start = start + findall(t->t .== minimum(waymatrix[(start-1):(start+1), j]), waymatrix[(start-1):(start+1), j])[1] - 2
        resvec[j] = start
    end
    return resvec
end


starts = 10:50:600
w = Vector{Vector{Int64}}(undef, length(starts))
max = maximum(waymatrix)
for (k,i) in enumerate(starts)
    w[k] = findway(i, waymatrix)
    for j in 1:size(waymatrix)[2]
        waymatrix[w[k][j]-1:w[k][j]+1, j] .= max
    end
end

heatmap(waymatrix)

way[end,:] = convolved[end,:]
for i in 1:(size(way, 1)-1)
    for j in 2:size(way, 2) - 1
        way[end-i, j] = minimum(way[end - i + 1, collect((j-1):(j+1))]) + convolved[end-i, j]
    end
end

test = deepcopy(way)


start = rand(751:800)
test[1, start] = maximum(test)
for i in 2:size(test)[1]
    start = start + (findfirst(t->t==minimum(test[i,collect(start-1:start+1)]), test[i,start-1:start+1]) - 2)
    test[i, start-1:start+1] .= maximum(test)
end
# Lägg "vägarna" i vektor och plotta med lines ist.?
fig = GLMakie.heatmap(test)
display(fig)
for i in 1:(size(test, 1)-1)
    for j in 2:size(test, 2) - 1
        test[end-i, j] = minimum(test[end - i + 1, collect((j-1):(j+1))]) + test[end-i, j]
    end
end




way2 = similar(convolved)
way2[:,end] = convolved[:,end]
for i in 1:(size(way2, 2)-1)
    for j in 2:size(way2, 1) - 1
        way2[j, end-i] = minimum(way2[collect((j-1):(j+1)), end - i + 1]) + convolved[j, end-i]
    end
end

test2 = deepcopy(way2)


start = rand(500:800)
test2[start, 1] = 40
for i in 2:size(test2)[2]
    start = start + (findfirst(t->t==minimum(test2[collect(start-1:start+1), i]), test2[start-1:start+1, i]) - 2)
    test2[start,i] = 40
end

GLMakie.heatmap(test2)

save("test.pdf", )




@time s = Laska.autocorrelogramfft(res, 33, 1)

fig=Laska.GLMakie.barplot((1:1499) ./ 30, real.(s[2:1500]))
display(fig)