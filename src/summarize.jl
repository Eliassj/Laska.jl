# Functions for summarizing clusters

function spikedict(p::Laska.PhyOutput)
    return Dict{Int64, Vector{Int64}}(c => p._spiketimes[p._spiketimes[:,1] .== c,2] for c in p._info[!,"cluster_id"])
end


function spikesper(p::Laska.PhyOutput, period::Float64 = 10.0)
    period = period * parse(Float64, p._meta["imSampRate"]) / 1000
    t = Matrix{Int64}(undef, size(p._spiketimes))
    t[:,1] = p._spiketimes[:,1]
    t[:,2] = Int.(ceil.(p._spiketimes[:,2] ./ period) .* period)
    #tmp::Matrix{Int64} = zeros(Int64, Int(maximum(t[:,2])/300)+1, 3)
    noll::Vector{Int64} = zeros(Int64, Int(maximum(t[:,2])/period)+1)
    tmp = Vector{Int64}(collect(0:period:Int(maximum(t[:,2]))))
    out = collect(Iterators.product(p._info[!,"cluster_id"], collect(0:period:Int(maximum(t[:,2])))))
    out = Matrix{Int64}(undef, Int((maximum(t[:,2])/period)+1)*size(p._info)[1], 3)
    out[:,2] = repeat(tmp, Int(size(out)[1] / length(tmp)))
    pos = 1
    for c in p._info["cluster_id"]
        for time in tmp
            
        end
    end
end