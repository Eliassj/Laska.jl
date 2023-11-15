module Laska

const standardcol = "#4C2C69"::String

using DataFrames
const dt = DataFrames
using MAT
using NPZ
using CSV
using Mmap
const mp = Mmap
using DSP
using StatsBase
using Statistics
using Graphs
using SimpleWeightedGraphs
using LinearAlgebra
LinAlg = LinearAlgebra
using MakieCore

# Type definitions
include("types/abstract.jl")
include("types/types.jl")
include("types/cluster.jl")
include("types/phyoutput.jl")

include("import/importmisc.jl")
include("import/importphy.jl")

# Helper functions
include("helpers/timeconv.jl")
include("helpers/rounding.jl")
include("helpers/spikesatdepth.jl")
include("helpers/normalize.jl")
include("helpers/unpackvector.jl")
include("helpers/isntempty.jl")
include("helpers/findmax.jl")
include("helpers/isi.jl")

# Work around triggers
include("triggers/relativespikes.jl")

# Summarizing statistics
include("summarize/cv2.jl")
include("summarize/frequency.jl")
include("summarize/relativefrequency.jl")

# Visualization
include("visualize/frequencyplot.jl")
include("visualize/recipes/frequencyrecipe.jl")

end
