# Representation of data

Entire experiments are represented using one of two structs. Each with an associated struct
for representing a single cluster/cell within an experiment:

- [`LaskaCore.PhyOutput`](@ref) containing [`LaskaCore.Cluster`](@ref)
- [`LaskaCore.RelativeSpikes`](@ref) containing [`LaskaCore.RelativeCluster`](@ref)

## PhyOutput

A `PhyOutput` is usually created by importing data using the [`LaskaCore.importphy`](@ref) function.
It contains:

- All variables found in the file cluster_info.tsv accessible through [`LaskaCore.info`](@ref).
- Recording meta data accessible through [`LaskaCore.getmeta`](@ref).
- A vector of triggertimes accessible through [`LaskaCore.triggertimes`](@ref).
- Clusters/cells represented as [`LaskaCore.Cluster`](@ref).

### Cluster

A [`LaskaCore.Cluster`](@ref) represents a single cluster/cell and holds the ID of the cluster, its spiketimes
and its corresponding row from the cluster_info.tsv file as a single-row DataFrame.

#### SpikeVector

A [`LaskaCore.SpikeVector`](@ref) is used for holding spiketimes in a [`LaskaCore.Cluster`](@ref).
Its only difference from a "normal" `Vector{T}` is that it also holds the samplerate of
its spiketimes which may be accessed with [`LaskaCore.samplerate`](@ref). This allows
`Unitful.jl` units to automatically be converted to the samplerate of the spiketimes.

## RelativeSpikes

A [`RelativeSpikes`](@ref) struct is similar to a `PhyOutput` in that it is meant to hold all `Cluster`s
from a single experiment. Most of the difference lies in that it holds [`RelativeCluster`](@ref)s.

`RelativeSpikes` structs are usually created with the [`LaskaCore.relativespikes`](@ref)
function. For more information on this see the section [Filter spikes around triggers](@ref).

### RelativeCluster

These only hold spiketimes around specified trigger events and each time is represented relative
to the event that it "belongs" to. Instead of `SpikeVector`s spiketimes are held in
`RelativeSpikeVector`s as described below.

#### RelativeSpikeVector

A [`LaskaCore.RelativeSpikeVector`](@ref) is analogous to a `Vector{Vector{T}}`, ie a vector
of vectors. Each sub-vector holds the spikes surrounding one trigger event. Spiketimes
are represented relative to the event rather than to recording start. A spike occurring 230ms before
the event will have a time of -230ms, a spike occuring _at_ the event 0ms and so on.
Indexing into the events/spiketimes is done like so: `vec[i][j]` which will return the
`j`:th spiketime of the `i`:th trigger event.
