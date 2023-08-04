using Laska
using Profile

@time res = Laska.PhyOutput(
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\23-04-24",
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0",
    "D:\\e1594\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0\\.laska\\e1594_Naive_Training_1h_Forelimb_1.5mA_CF_250uA_g0_imec0.bin"
)

@time tes = Laska.relativeSpikes(res, context = Dict("US" => 0, "CS" => 300))

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
#end


data = Laska.getchan(res, 375:385, 0, 0.3, true, true)

Laska.plotchannels(res, 375:385, 0, 0.1)

Laska.plotraster(tes, 33)

for x in sort(tes._stimulations, byvalue = true)
    println(x[2], "(",x[1],")")
end

d = sort(tes._stimulations, byvalue = true)

["$v($k)" for (k, v) in collect(d)]