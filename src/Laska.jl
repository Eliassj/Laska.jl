module Laska

using DataFrames
const dt = DataFrames
using Gtk
using MAT
using NPZ
using CairoMakie
const plt = CairoMakie
using CSV
using Mmap
const mp = Mmap


include("i.jl")
include("e.jl")
include("p.jl")
end
