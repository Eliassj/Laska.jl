##########################################
#
using Base: source_dir
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
    # Make/preallocate source-, destination- and weight vectors
    edgepairs::Matrix{Int64} = expandgrid(getclusters(p))
    sources = edgepairs[1, :]
    destinations = edgepairs[2, :]
    weights::Vector{Float64} = Vector{Float64}(undef, length(destinations))
    # Copy vars from info df
    vars = deepcopy(p._info[!, append!(["cluster_id"], edgevariables)])
    # Normalize variables between 0-1
    for col in edgevariables
        vars[!, col] = normalize(vars[!, col])
    end
    # Prepare a dict cluster => normalized variables
    vardict::Dict{Int64,Vector{Float64}} = Dict(
        vars[r, "cluster_id"] => Vector{Float64}(vars[r, Not("cluster_id")]) for r in 1:length(getclusters(p))
    )
    # Calculate weight vector
    # Currently calculated as euclidean distance with a gaussian kernel (||x1 - x2||^2/(2*gamma^2))
    #gamma = maximum(maximum(values(vardict))) * 0.15
    gamma = 1
    n = 1
    for (s, d) in zip(sources, destinations)
        weights[n] = exp(-sum((vardict[vdict[s]] .- vardict[vdict[d]]) .^ 2) / (2 * (gamma^2)))
        n += 1
    end
    # Make graph
    graph = SimpleWeightedGraph(sources, destinations, weights)

    return graph
end

function KNNclustergraph(p::PhyOutput, edgevariables::Vector, k::Int64)
    sources, destinations = expandgrid(getclusters(p), true)
    weights::Vector{Float64} = Vector{Float64}(undef, length(destinations))
    # Copy vars from info df
    vars = deepcopy(p._info[!, append!(["cluster_id"], edgevariables)])
    # Normalize variables between 0-1
    for col in edgevariables
        vars[!, col] = normalize(vars[!, col])
    end
    vardict::Dict{Int64,Vector{Float64}} = Dict(
        vars[r, "cluster_id"] => Vector{Float64}(vars[r, Not("cluster_id")]) for r in 1:length(getclusters(p))
    )
    # Calculate weight vector
    # Currently calculated as euclidean distance with a gaussian kernel (||x1 - x2||^2/(2*gamma^2))
    #gamma = maximum(maximum(values(vardict))) * 0.15
    gamma = 1
    n = 1
    for (s, d) in zip(sources, destinations)
        weights[n] = exp(-sum((vardict[vdict[s]] .- vardict[vdict[d]]) .^ 2) / (2 * (gamma^2)))
        n += 1
    end
end

function KNNify(
    sources::Vector{Int64},
    destinations::Vector{Int64},
    weights::Vector{Float64},
    k::Int64)
    maxindxs::Vector{Int64} = Vector{Int64}(undef, k)
    for src in sources

    end

end

function removesmalledges(g::SimpleWeightedGraphs.SimpleWeightedGraph{Int64,Float64}, cutoff::Float64)
    for e in Laska.edges(g)
        if weight(e) < cutoff
            rem_edge!(g, e)
        end
    end
end

function normalizedlaplacian(g::SimpleWeightedGraphs.SimpleWeightedGraph{Int64,Float64}; type::String="rw")
    deg = degree_matrix(g)
    adj = adjacency_matrix(g)
    if type == "sym"
        return deg^(-1 / 2) * adj * deg^(-1 / 2)
    elseif type == "rw"
        return pinv(collect(deg)) * collect(adj)
    end
end

function eigencut!(g::SimpleWeightedGraphs.SimpleWeightedGraph{Int64,Float64}, eigvecs::Matrix{Float64}, nvec::Int)
    removededges::Vector{SimpleWeightedEdge{Int64,Float64}} = []
    for e in edges(g)
        if eigvecs[src(e), nvec] * eigvecs[dst(e), nvec] < 0
            push!(removededges, e)
            rem_edge!(g, e)
        end
    end
    return Dict{Int64,Int64}(n => sign.(eigvecs[:, nvec])[n] for n in Laska.vertices(g))
end

# Eigencuts with tresholds
function eigencut!(g::SimpleWeightedGraphs.SimpleWeightedGraph{Int64,Float64}, eigvecs::Matrix{Float64}, nvec::Int; etresh::Float64)
    removededges::Vector{SimpleWeightedEdge{Int64,Float64}} = []
    for e in edges(g)
        if (eigvecs[src(e), nvec] > etresh || eigvecs[dst(e), nvec] > etresh) && eigvecs[src(e), nvec] * eigvecs[dst(e), nvec] < 0
            rem_edge!(g, e)
            push!(removededges, e)
        end
    end
    return removededges
end

function ploteigenvector(eig::Matrix, n::Int)
    vec = eig[:, n]
    srt = sortperm(vec)
    f, ax, tr = scatter(
        1:length(vec),
        vec[srt]
    )
    display(f)
end

"""

    maxeigvec(eigvecs::Matrix{Float64})

Returns which eigenvector has the greatest mean of squared values.          

"""
function maxeigvec(eigvecs::Matrix{Float64})
    comp::Vector{Float64} = Vector(undef, size(eigvecs, 2))
    for (n, v) in enumerate(eachcol(eigvecs))
        comp[n] = mean(v .^ 2)
    end
    return findmax(comp)[2]
end
