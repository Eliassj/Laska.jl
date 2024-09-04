# Importing data processed in Phy

Importing Phy output data is done using [`LaskaCore.importphy`](@ref). This will return a
[`LaskaCore.PhyOutput`](@ref) struct holding all units/clusters, their spiketimes and
related information.

#### Basic usage

The method below will import data found in `"path/to/phy/output"`. By default, only "good" clusters as found in "cluster*info.tsv" will be included. Setting `includemua` to `false` will include \_all* clusters.

```julia
result = importphy("path/to/phy/output")
```

In order to include spikeGLX metadata and/or a specific channel (exported from spikeGLX) with trigger events, paths to these must be included.
For spikeGLX metadata, a path to the folder containing the .meta file is enough. For triggerchannel, a direct path is required.

```julia
result = importphy(
    "path/to/phy/output",
    "path/to/spikeGLX/meta",
    "path/to/triggerchannel.bin"
)
```

#### Filtering clusters

Clusters may be easily filtered on import based on variable(s) in "cluster_info.tsv"
by including `filter` as a keyword argument.

A `filter` is anything that may be passed as the first argument when filtering a `DataFrame`.
For more information on this please see the `DataFrames.jl` [documentation](https://dataframes.juliadata.org/stable/lib/functions/#Base.filter).

Several `filters` may be included by wrapping them in a Vector.

###### Example

In the example below, we create a filter with a function that will return `true` if `x > 1`
and apply it to the cluster_info.tsv variable `:fr`. This will cause only clusters with a
mean fire rate of more than 1Hz to be included in the `result`.

```julia
result = importphy(
    "path/to/phy/output",
    "path/to/spikeGLX/meta",
    "path/to/triggerchannel.bin",
    filter = :fr => x -> x > 1.0
)
```
