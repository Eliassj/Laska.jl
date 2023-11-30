# Importing data processed in Phy

Importing Phy output data is done using [`LaskaCore.importphy`](@ref). This will return a
[`LaskaCore.PhyOutput`](@ref) struct.

#### Basic usage

The method below will import data found in `"path/to/phy/output"`. By default, only "good" clusters as found in "cluster\_info.tsv" will be included. Setting `includemua` to `false` will include *all* clusters.

```julia
result = importphy("path/to/phy/output")
```

In order to include spikeGLX metadata and/or a specific channel (exported from spikeGLX) with trigger events paths to these must be included. For spikeGLX metadata, a path to the folder containing the .meta
file is enough. For triggerchannel, a direct path is required.

```julia
result = importphy(
    "path/to/phy/output",
    "path/to/spikeGLX/meta",
    "path/to/triggerchannel.bin"
)
```

#### Filtering clusters

Clusters may be easily filtered on import based on variable(s) found in "cluster\_info.tsv"
by including a `filter` as the second argument.

A `filter` is a Tuple with 2 entries:

- A `Symbol` matching a column in "cluster\_info.tsv".\
- A `Function` returning `true`/`false` applicable to the specified column.

Several `filters` may be included by wrapping them in an outer Tuple.

###### Example

In the example below, we create a filter with a function that will return `true` if `x > 1`
and apply it to the cluster\_info.tsv variable `:fr`. This will cause only clusters with a
firerate of more than 1Hz to be included in the `result`.

```julia
function f(x)
    return x>1
end

filter = (:fr, f)

result = importphy(
    "path/to/phy/output",
    filter,
    "path/to/spikeGLX/meta",
    "path/to/triggerchannel.bin"
)
```

