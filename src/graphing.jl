##########################################
#
# Create graph representation of clusters
#
##########################################


"""
    clustergraph(p::PhyOutput, edgevariables::Vector{String})

Construct a weighted graph of clusters.         
Weights are currently computed as 1 divided by the summed absolute difference of variables between vertices/clusters.

# Variables      
`p::PhyOutput` --- Phyoutput as created by [`PhyOutput`](@ref).         
`edgevariables` --- Variables with which to compute weights of edges.


"""
function clustergraph(p::PhyOutput, edgevariables::Vector{String})
    # Create dictionary edge label => cluster
    vdict::Dict{Int64, Int64} = Dict(
        n => getclusters(p)[n] for n in eachindex(getclusters(p))
    )
    # Create dictionary cluster => edge label
    cdict::Dict{Int64, Int64} = Dict(
        c => v for (v,c) in pairs(vdict)
    )
    # Make/preallocate source-, destination- and weight vectors
    edgepairs = expandgrid(collect(keys(vdict)))
    sources = edgepairs[1,:]
    destinations = edgepairs[2,:]
    weights::Vector{Float64} = Vector{Float64}(undef, length(destinations))
    # Copy vars from info df
    vars = deepcopy(p._info[!, append!(["cluster_id"], edgevariables)])
    # Normalize variables between 0-1
    for col in edgevariables
        vars[!,col] = normalize(vars[!,col])
    end
    # Prepare a dict cluster => normalized variables
    vardict::Dict{Int64, Vector{Float64}} = Dict(
        vars[r, "cluster_id"] => Vector{Float64}(vars[r, Not("cluster_id")]) for r in 1:length(getclusters(p))
    )
    # Compute weight vector
    n = 1
    for (s, d) in zip(sources, destinations)
        weights[n] = 1 / sum(abs.(vardict[vdict[s]] .- vardict[vdict[d]]))
        n += 1
    end
    # Make graph
    graph = SimpleWeightedGraph(sources, destinations, weights)

    return graph, vdict, cdict
end