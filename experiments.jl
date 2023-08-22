using Laska
using TSne
using Statistics
using GLMakie
using DSP
using CairoMakie
using GraphMakie


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


Laska.mad!(p)
Laska.cv2(p, true)
Laska.medianisi!(p)

g, vd, cd = Laska.clustergraph(p, ["depth", "mad", "cv2median", "median_isi"])

Laska.weight.(Laska.edges(g))

cd[1009]

collect(Laska.Graphs.weights(g))
GLMakie.activate!()

f, ax, tr = graphplot(
    g,
    nlabels = repr.(
        [vd[v] for v in Laska.vertices(g)]
    ),
    edge_color = Laska.weight.(Laska.edges(g)),
    edge_width = Laska.weight.(Laska.edges(g)) ./ 10
)
Colorbar(f[1,2], limits = (0, maximum(Laska.weight.(Laska.edges(g)))))
display(f)

maximum(Laska.weight.(Laska.edges(g)))