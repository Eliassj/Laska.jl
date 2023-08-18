#############################
#
# Helper functions
#
#############################

function getdepths(p::PhyOutput)
    return unique(p._info[!, "depth"])
end

function  getdepths(t::relativeSpikes)
    return unique(t._info[!, "depth"])
end

function getclusters(p::PhyOutput)
    return p._info[!, "cluster_id"]
end

function getclusters(t::relativeSpikes)
    return t._info[!, "cluster_id"]
end

function nclusters(t::relativeSpikes)
    return length(t._info[!, "cluster_id"])
end

function nclusters(p::PhyOutput)
    return length(p._info[!, "cluster_id"])
end

function getspiketimes(p::PhyOutput)
    return p._spiketimes
end

function getspiketimes(t::relativeSpikes)
    return t._spiketimes
end


function ntriggers(t::relativeSpikes)
    return t._specs["ntrig"]
end