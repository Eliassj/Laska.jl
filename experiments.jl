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
LinAlg=LinearAlgebra
using GraphMakie.NetworkLayout

#%%
ffr = :fr => x -> x > 1
#%%

@time res = Laska.PhyOutput(
    "/run/media/elias/T7/e1594/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0/23-04-24/",
    "/run/media/elias/T7/e1594/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0/",
    "/run/media/elias/T7/e1594/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0/.laska/e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0.bin",
    filters = (ffr,)
)

@time tes = Laska.relativeSpikes(res, context = Dict("US" => 0, "CS" => 300))


data = Laska.getchan(res, 375:385, 0, 0.3, true, true)

Laska.plotchannelsinteractive(res, 375:385, 0, 0.1)

Laska.GLMakie.activate!()
Laska.plotraster(tes, 158)

s = Scene()

p = deepcopy(res)
Laska.mad!(p)
Laska.cv2(p, true)
Laska.medianisi!(p)

g, vd, cd = Laska.clustergraph(p, ["mad", "cv2median", "median_isi"])

Laska.removesmalledges(g, 0.3)

ed = collect(Laska.edges(g))
Laska.dst(ed[1])

hist(Laska.weight.(Laska.edges(g)), bins=500)

norm=collect(Laska.normalizedlaplacian(g))

srt = sortperm(eig[:,3])
heatmap(collect(Laska.adjacency_matrix(g))[srt, srt])


collect(Laska.Graphs.weights(g))
GLMakie.activate!()



heatmap(eig)

Laska.ploteigenvector(eig, 33)
srt = sortperm(eig[:,3])
text(1:length(eig[:,2]), eig[:,3][srt], text=repr.([vd[v] for v in 1:52]))

Laska.greedy_color(g)

heatmap(eig)
hist(eig[:,1], bins=500)

A = collect(Laska.normalizedlaplacian(g))
eig = real.(LinAlg.eigvecs(A))
eigvals = LinAlg.eigvals(A)

Laska.maxeigvec(eig)

Laska.eigencut!(g, eig, 5, etresh = 0.1)
plotit()
scatter(eigvals)
scatter(eig[:,33])

while length(Laska.connected_components(g)) < 15
    A = collect(Laska.normalizedlaplacian(g))
eig = real.(LinAlg.eigvecs(A))
r=Laska.eigencut!(g, eig, Laska.maxeigvec(eig), etresh = 0.01)
    println(r)
end

collect(Laska.edges(g))

c=Laska.Graphs.normalized_cut(g, 0.3)

text(p._info[!,"cv2median"], p._info[!,"depth"], text=repr.(p._info[!,"cluster_id"]), color=c)

function plotit()
f, ax, tr = graphplot(
    g,
    nlabels = repr.(
        [vd[v] for v in Laska.vertices(g)]
    ),
    edge_color = Laska.weight.(Laska.edges(g)),
    edge_width = Laska.normalize!(Laska.weight.(Laska.edges(g)), 0.5,4)#,
    #layout=Spring(;dim=3)
)
Colorbar(f[1,2], limits = (0, maximum(Laska.weight.(Laska.edges(g)))))
display(f)
end

