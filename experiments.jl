using Laska
using Profile

@time res = Laska.PhyOutput(
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uAre_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\.laska\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0.bin"
)
@in
@time tes = Laska.relativeSpikes(res, context = Dict("US" => 0, "CS" => 300))


data = Laska.getchan(res, 375:385, 0, 0.3, true, true)

Laska.plotchannelsinteractive(res, 375:385, 0, 0.1)

Laska.plotraster(tes, 33)

for x in sort(tes._stimulations, byvalue = true)
    println(x[2], "(",x[1],")")
end

d = sort(tes._stimulations, byvalue = true)

["$v($k)" for (k, v) in collect(d)]