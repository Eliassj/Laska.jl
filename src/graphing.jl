##########################################
#
# Create graph representation of clusters
#
##########################################


function clustergraph(p::PhyOutput, edgevariables::Tuple{String})
    edgepairs = expandgrid(getclusters(p))
end