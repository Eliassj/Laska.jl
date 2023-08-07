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


include("i.jl") # Import functions
include("misc.jl") # qol/helper functions
include("e.jl") # Export functions
include("t.jl") # Transforming functions
include("p.jl") # Plotting/visualization
include("summarize.jl")
#include("interactive.jl")
end
