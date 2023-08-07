function getclusters(p::PhyOutput)
    return p._info[!, "cluster_id"]
end