module Laska

using DataFrames
const dt = DataFrames
using Gtk
using MAT
using NPZ
using GLMakie
const plt = GLMakie
using CSV
using Mmap
const mp = Mmap
using LoopVectorization


include("i.jl")
include("e.jl")
include("p.jl")
end
