module Laska

const standardcol = "#4C2C69"::String

using DataFrames
const dt = DataFrames
using Gtk
using MAT
using NPZ
using GLMakie
using CairoMakie
using CSV
using Mmap
const mp = Mmap
using LoopVectorization
using DataStructures
using DSP
using StatsBase
using Graphs
using SimpleWeightedGraphs
using LinearAlgebra
LinAlg = LinearAlgebra
using FFTW
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

include("filter.jl") # Filter spikes
#include("t.jl") # Transforming functions
include("misc.jl") # qol/helper functions
include("e.jl") # Export functions
include("p.jl") # Plotting/visualization
include("summarize.jl") # Summarize by time, depth, etc
include("clustering.jl") # Clustering
include("graphing.jl") # Create graph representations
include("importknown.jl")
include("interactive.jl")
include("responseplot.jl")
end

