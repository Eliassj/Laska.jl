using Laska

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

p=Laska.plotraster(tes, 1060)

s = Scene()
