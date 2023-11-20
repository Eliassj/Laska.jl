# Importing data processed in Phy

Importing Phy output data is done using [`Laska.importphy`](@ref). This will return a
[`Laska.PhyOutput`](@ref) struct.

## Methods

###### "Basic"

The method below will import all clusters found in `phydir`. By default, only "good" clusters as found in "cluster_info.tsv" will be included. Setting `includemua` to `false` will include all clusters.

```julia
importphy(phydir::String, glxdir::String, triggerpath::String; includemua::Bool=false)
```

###### Methods with filters

These methods include `filters` which may be used to exclude clusters based on variables
found in "cluster_info.tsv".\
`filters` are a Tuple with 2 entries:\
A `Symbol` matching a column in "cluster_info.tsv".\
A `Function` returning `true`/`false` applicable to the specified column.

Several `filters` may be included by wrapping them in a Tuple.

```julia
importphy(phydir::String, filters::Tuple{Symbol,Function}, glxdir::String="", triggerpath::String=""; includemua::Bool=false)

importphy(phydir::String, filters::Tuple{Tuple{Symbol,Function}}, glxdir::String="", triggerpath::String=""; includemua::Bool=false)
```



### Arguments

##### Directories

3 directories may be provided in the form of their path(s) as Strings.

Currently, only 1 of these is *required*:\
`phydir` -- The directory containing the files "cluster_info.tsv", "spike_clusters.npy" & "spike_times.npy"

Other arguments are optional and include:\
`glxdir` -- Directory containing meta information from spikeGLX (*.meta). The metafile is
parsed to a Dict and may be retrieved using [`Laska.getmeta`](@ref)\
`triggerpath` -- Direct path to a .csv or .bin file exported from spikeGLX containing a
single channel.

```julia

```

An optional `triggerpath` pointing directly to a single trigger channel exported from spikeGLX may be supplied.A .csv or .bin is accepted. For long recordings, a .csv file may be noticeably slower to read than a .bin file.
