module Laska

standardcol::String = "#4C2C69"

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
using SimpleWeightedGraphs
using FFTW

include("types.jl")
include("filter.jl")
include("i.jl") # Import functions
include("t.jl") # Transforming functions
include("misc.jl") # qol/helper functions
include("e.jl") # Export functions
include("p.jl") # Plotting/visualization
include("summarize.jl")
include("clustering.jl")

#include("interactive.jl")
end
