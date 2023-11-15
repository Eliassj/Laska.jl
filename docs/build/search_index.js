var documenterSearchIndex = {"docs":
[{"location":"#Laska.jl-documentation","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"using Laska","category":"page"},{"location":"#Summarizing-statistics","page":"Laska.jl documentation","title":"Summarizing statistics","text":"","category":"section"},{"location":"#Calculating-CV2","page":"Laska.jl documentation","title":"Calculating CV2","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.cv2(cluster::Laska.Cluster)","category":"page"},{"location":"#Laska.cv2-Tuple{Laska.Cluster}","page":"Laska.jl documentation","title":"Laska.cv2","text":"cv2(cluster::Cluster)\n\nReturns CV2 values of cluster as a vector.\n\nCV2 is calculated according to:\n\nCV2 = frac2ISI_n+1 - ISI_n(ISI_n+1 + ISI_n)\n\n\n\n\n\n","category":"method"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.cv2mean(cluster::Laska.Cluster)","category":"page"},{"location":"#Laska.cv2mean-Tuple{Laska.Cluster}","page":"Laska.jl documentation","title":"Laska.cv2mean","text":"cv2mean(cluster::Cluster)\n\nCalculates the mean CV2 of cluster.\n\n\n\n\n\n","category":"method"},{"location":"#Calculating-frequency","page":"Laska.jl documentation","title":"Calculating frequency","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.frequency(cluster::Laska.Cluster, interval::T) where {T<:Real}","category":"page"},{"location":"#Laska.frequency-Union{Tuple{T}, Tuple{Laska.Cluster, T}} where T<:Real","page":"Laska.jl documentation","title":"Laska.frequency","text":"frequency(cluster::Cluster, period::T) where {T<:Real}\n\nReturns a Vector containing the frequency of the cluster in the form of spikes/period binned at each multiple of period.             Spiketimes are binned to the next largest multiple of period. Ie a spike happening at time = 30001 will be in the 60000 bin.\n\nExample\n\nFor a cluster sampled at 30 000Hz...\n\nLaska.frequency(cluster, 30000)\n\n...will return spikes/second.\n\nIndexing into the result as:        \n\nresult[n]\n\nWill return the n:th bin which describes the number of spikes occuring between period * n and period * n-1.\n\n\n\n\n\n","category":"method"},{"location":"#Helpers","page":"Laska.jl documentation","title":"Helpers","text":"","category":"section"},{"location":"#Spike-filtering","page":"Laska.jl documentation","title":"Spike filtering","text":"","category":"section"},{"location":"#By-depth","page":"Laska.jl documentation","title":"By depth","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.spikesatdepth(p::Laska.PhyOutput{T}, depth::N) where {T<:Real} where {N<:Real}","category":"page"},{"location":"#Laska.spikesatdepth-Union{Tuple{T}, Tuple{N}, Tuple{Laska.PhyOutput{T}, N}} where {N<:Real, T<:Real}","page":"Laska.jl documentation","title":"Laska.spikesatdepth","text":"spikesatdepth(p::PhyOutput{T}, depth::N) where {T<:Real} where {N<:Real}\nspikesatdepth(p::PhyOutput{T}, depth::Tuple{2,N}) where {T<:Real} where {N<:Real}\nspikesatdepth(p::PhyOutput{T}, depth::Set{N}) where {T<:Real} where {N<:Real}\n\nReturns a Vector{T} of all spiketimes at/in depth.\n\nThe included depths are controlled by the type of the depth variable:                 \n\nA single number returns only the spikes of clusters at that exact depth.                  \nA Tuple with 2 entries returns all clusters at depths between (and including) the values.                  \n\nrelativefrequency(vec::Vector{Vector{T}}, period::N) where {T<:Real,N<:Real}\n\nA Set returns the clusters with the exact depths in the Set.\n\n\n\n\n\n","category":"method"},{"location":"#Rounding","page":"Laska.jl documentation","title":"Rounding","text":"","category":"section"},{"location":"#roundup()","page":"Laska.jl documentation","title":"roundup()","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.roundup(value::T, interval::N) where {T<:Real} where {N<:Real}","category":"page"},{"location":"#Laska.roundup-Union{Tuple{T}, Tuple{N}, Tuple{T, N}} where {N<:Real, T<:Real}","page":"Laska.jl documentation","title":"Laska.roundup","text":"roundup(value::T, interval::N) where T<:Real where N<:Real\n\nRounds value up to the nearest greater multiple of interval.\n\n\n\n\n\n","category":"method"},{"location":"#Examples","page":"Laska.jl documentation","title":"Examples","text":"","category":"section"},{"location":"","page":"Laska.jl documentation","title":"Laska.jl documentation","text":"Laska.roundup(12, 30)\nLaska.roundup(12, 23)\nLaska.roundup(12.5, 1)\nLaska.roundup(12, 3.8)","category":"page"}]
}
