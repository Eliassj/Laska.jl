using Base: Forward
#%%
using Laska
using TSne
using Statistics
using GLMakie
using DSP
using CairoMakie
using GraphMakie
using SimpleWeightedGraphs
using LinearAlgebra
LinAlg = LinearAlgebra
using GraphMakie.NetworkLayout

#%%
ffr = :fr => x -> x > 1
#%%

@time res = Laska.importphy(
    "/home/elias/illerdata",
    "/home/elias/illerdata",
    "/home/elias/illerdata/triggerchane15941h.bin",
    filters=(ffr,)
)

@time tes = Laska.relativeSpikes(res, Dict("US" => 300, "CS" => 0), forward=600)


data = Laska.getchan(res, 375:385, 0, 0.3, true, true)

Laska.plotchannelsinteractive(res, 375:385, 0, 0.1)

Laska.GLMakie.activate!()
Laska.plotraster(tes, 158)

s = Scene()

p = deepcopy(res)
Laska.mad!(p)
Laska.cv2(p, true)
Laska.medianisi!(p)julia recompilation

g, vd, cd = Laska.clustergraph(p, ["mad", "cv2median", "median_isi"])

Laska.removesmalledges(g, 0.5)

ed = collect(Laska.edges(g))
Laska.dst(ed[1])

hist(Laska.weight.(Laska.edges(g)), bins=500)

norm = collect(Laska.normalizedlaplacian(g))

srt = sortperm(eig[:, 3])
heatmap(collect(Laska.adjacency_matrix(g))[srt, srt])


collect(Laska.Graphs.weights(g))
GLMakie.activate!()



heatmap(eig)

Laska.ploteigenvector(eig, 10)
srt = sortperm(eig[:, 3])
text(1:length(eig[:, 2]), eig[:, 3][srt], text=repr.([vd[v] for v in 1:52]))

Laska.greedy_color(g)

heatmap(eig)
hist(eig[:, 1], bins=500)

A = collect(Laska.normalizedlaplacian(g))
eig = LinAlg.eigvecs(A)
eigvals = LinAlg.eigvals(A)

Laska.maxeigvec(eig)

Laska.eigencut!(g, eig, 10)
plotit()
scatter(eigvals)
scatter(eig[:, 10])



collect(Laska.edges(g))

c = Laska.Graphs.normalized_cut(g, 0.3)

Laska.text(p._info[!, "cv2median"], p._info[!, "depth"], text=repr.(p._info[!, "cluster_id"]), color=c)

function plotit()
    f, ax, tr = graphplot(
        g,
        nlabels=repr.(
            [vd[v] for v in Laska.vertices(g)]
        ),
        edge_color=Laska.weight.(Laska.edges(g)),
        edge_width=Laska.normalize!(Laska.weight.(Laska.edges(g)), 0.5, 4)#,
        #layout=Spring(;dim=3)
    )
    Colorbar(f[1, 2], limits=(0, maximum(Laska.weight.(Laska.edges(g)))))
    display(f)
end


stab = Laska.stability(res, mdfactor = .4, period = 10000)

for c in Laska.getclusters(res)
    println(c, ": ", stab[c])
end

r = Laska.spikesper(res, 10000)

cluster = 380
data = r[r[:, 1].==cluster, 3]
sd = Statistics.median(data)
fr = filter(:cluster_id => x -> x == cluster, res._info)[!, "fr"][1]
fig = Figure()
ax = Axis(fig[1, 1])
lines!(
    ax,
    data
)
hlines!(
    [sd - (sd * 0.4), sd + (sd * 0.4)],
    color=:red
)
display(fig)

relative1 = Laska.relresponse(tes, 25, Laska.clusterbaseline(tes))

cluster = 33
relative = relative1[relative1[:, 1].==cluster, 3]

data2 = Laska._convolveresponse(relative, 10)


fig = Figure()
ax = Axis(fig[1, 1])
lines!(
    ax,
    relative
)
display(fig)
