using Laska
using Profile

@time res = Laska.PhyOutput(
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0",
    "E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24\\768.exported.imec0.ap.csv"
)

@time trik = Laska.getchan(res, 385, 0, "max", false, true)

#d=open("E:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_t0.imec0.ap.bin", "r")
#
#position(d)
#iswritable(d)
# # open file for reading
#Nbytes = sizeof(Int16) # number of bytes per element
#seek(d, (385)*Nbytes*3) # move to the 3rd element
#val = read(d, Int16) # read a Float32 element
#close(io)
#
#function readchan(path::String, ch::Int, t::Unitrange{Int})
#    f = open(path, "r")
#    
#end#


data = Laska.getchan(res, 380:385, 0, 0.5, true, true)

Laska.plotchannels(res, 1:100, 0, 0.1)