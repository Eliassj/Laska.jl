# Structs and their Interfaces

```@index
Pages = ["structs.md"]
```

## Abstract types

### AbstractExperiment

```@docs
Laska.AbstractExperiment{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`Laska.AbstractExperiment`](@ref).

```@docs
Laska.clusterids
```

```@docs
Laska.getcluster
```

```@docs
Laska.clustervector
```

```@docs
Laska.getmeta
```

```@docs
Laska.triggertimes
```

```@docs
Laska.ntrigs
```

### AbstractCluster

```@docs
Laska.AbstractCluster{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`Laska.AbstractCluster`](@ref).

```@docs
Laska.id
Laska.nspikes
Laska.info
Laska.spiketimes
```
## Concrete types

### "Experiment" wrappers

This section descrives concrete types for holding entire experiments including their clusters and metadata.

#### PhyOutput

```@docs
Laska.PhyOutput
```

#### RelativeSpikes

```@docs
Laska.RelativeSpikes
```

##### Interfaces

Interfaces only for use with [`Laska.RelativeSpikes`](@ref).

```@docs
Laska.relativespecs
```

```@docs
Laska.stimtimes
```

### Single cluster wrappers

#### Cluster

```@docs
Laska.Cluster
```

#### RelativeCluster

```@docs
Laska.RelativeCluster
```
