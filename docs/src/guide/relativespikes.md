# Filter spikes around triggers

Filtering an entire experiment, only keeping spikes around triggers/events, can be accomplished
using [`LaskaCore.relativespikes`](@ref). This function returns a [`LaskaCore.RelativeSpikes`](@ref)-struct
which is similar to a [`LaskaCore.PhyOutput`](@ref)-struct with a few differences. Most importantly,
instead of as [`LaskaCore.Cluster`](@ref), individual cells are represented as [`LaskaCore.RelativeCluster`](@ref)s. Instead of
a single vector of sequential spiketimes the `RelativeCluster` holds a vector of vectors. Each sub-vector represents
one trigger event and holds all spiketimes surrounding that event. Spiketimes are also converted
to be represented as relative to each event instead of absolute time from recording start.

## Example

In a classical conditioning experiment, one might apply a conditioned stimulation (CS) followed by
an unconditioned stimulation (US) several times over the course of an experiment. Filtering the data
and specifying the experimental setup for further visualization and/or analysis may be done in the following manner:

```julia
using LaskaCore

# In order to specify times in seconds/milliseconds instead of the recording samplerate
using Unitful

# Import our data
data_raw = importphy("path/to/phyoutput", "path/to/glxmeta", "path/to/triggerchannel.bin")

# Filter all spikes and create a RelativeSpikes struct
data_filtered = relativespikes(
    data_raw,
    # Pass a `Dict` describing the stimulations. Here, "CS" occurs
    # at the trigger and "US" occurs 300ms following the trigger.
    Dict(
        "CS" => 0u"ms",
        "US" => 300u"ms"
    ),
    1000u"ms", # Amount of time before each trigger to include
    1500u"ms" # Amount of time after each trigger to include
)
```
