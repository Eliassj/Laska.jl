module Laska

const standardcol = "#4C2C69"::String

using DataFrames
const dt = DataFrames
using MAT
using NPZ
using GLMakie
using CSV
using Mmap
const mp = Mmap
using DSP
using StatsBase
using Graphs
using SimpleWeightedGraphs
using LinearAlgebra
LinAlg = LinearAlgebra
using MakieCore
using InvertedIndices

# Type definitions
include("types/abstract.jl")
include("types/types.jl")
include("types/cluster.jl")
include("types/phyoutput.jl")

include("import/importmisc.jl")
include("import/importphy.jl")

include("helpers/timeconv.jl")

# Work around triggers
include("triggers/relativespikes.jl")

end
