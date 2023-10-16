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
    sources = getclusters(p)
    adjmatrix::Matrix{Float64} = Matrix{Float64}(undef, length(sources), length(sources))
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
    compare::Vector{Float64} = Vector{Float64}(undef, length(edgevariables))
    gamma::Float64 = 1.0
    for n in eachindex(sources)
        compare = vardict[sources[n]]
        @simd for m in eachindex(sources)
            @inbounds adjmatrix[m, n] = gaussiankernel(compare, vardict[sources[m]], gamma)
        end
    end
    # remove circular edges
    for n in eachindex(sources)
        adjmatrix[n, n] = 0.0
    end
    # Make graph
    graph = SimpleWeightedGraph(adjmatrix)

    return graph, sources, adjmatrix
end

function clustergraph(p::PhyOutput, edgevariables::Vector{String}, k::Int64)
    # Make/preallocate source-, destination- and weight vectors
    sources = getclusters(p)
    adjmatrix::Matrix{Float64} = Matrix{Float64}(undef, length(sources), length(sources))
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
    compare::Vector{Float64} = Vector{Float64}(undef, length(edgevariables))
    gamma::Float64 = 1.0
    for n in eachindex(sources)
        compare = vardict[sources[n]]
        @simd for m in eachindex(sources)
            @inbounds adjmatrix[m, n] = gaussiankernel(compare, vardict[sources[m]], gamma)
        end
    end
    # remove circular edges
    for n in eachindex(sources)
        adjmatrix[n, n] = 0.0
    end
    # KNNify
    filtervec::Vector{Bool} = Vector{Bool}(undef, length(sources))
    filtervec .= true
    for n in eachindex(sources)
        sr::Vector{Int64} = partialsortperm(adjmatrix[:, n], 1:k, rev=true)
        filtervec[sr] .= false
        v = @view adjmatrix[:, n]
        v[filtervec] .= 0.0
        v = @view adjmatrix[n, :]
        v[filtervec] .= 0.0
        filtervec .= true
    end
    # Make graph
    graph = SimpleWeightedGraph(adjmatrix)

    return graph, sources, adjmatrix

end



function gaussiankernel(v1::Vector{Float64}, v2::Vector{Float64}, gamma::Float64)
    return exp(-(euclideandistance(v1, v2)^2) / (2 * (gamma^2)))
end

@inline function euclideandistance(v1::Vector{Float64}, v2::Vector{Float64})
    out = 0.0
    for i::Int64 in eachindex(v1)
        @inbounds out += (v1[i] - v2[i])^2
    end
    return sqrt(out)
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
        return (deg^(-1 / 2) * adj * deg^(-1 / 2))
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
