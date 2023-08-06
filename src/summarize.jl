# Functions for summarizing clusters

function spikedict(p::Laska.PhyOutput)
    return Dict{Int64, Vector{Int64}}(c => p._spiketimes[p._spiketimes[:,1] .== c,2] for c in p._info[!,"cluster_id"])
end


function spikesper(p::Laska.PhyOutput, period::Int16)
    



end