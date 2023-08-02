using Laska
using Profile

@time res = Laska.PhyOutput(
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24\\768.exported.imec0.ap.csv"
)

@time Laska.getchan(res, 384, 0, "max", false, true)