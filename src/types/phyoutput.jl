###########################################################
# 
# Container for all Clusters that are part of an experiment
#
###########################################################

mutable struct PhyOutput{T}
    cellids::Vector{Int64}
    clusters::Vector{Cluster{T}}
    trigtimes::Vector{T}
    meta::Dict{SubString{String},SubString{String}}

end


function getcell(experiment::PhyOutput, cell::Int64)
    return experiment.clusters[findfirst(x -> x == cell, experiment.cellids)]
end
