# Structs and their Interfaces


## Abstract types

### AbstractExperiment

```@docs
LaskaCore.AbstractExperiment{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`LaskaCore.AbstractExperiment`](@ref).

```@docs
LaskaCore.clusterids
```

```@docs
LaskaCore.getcluster
```

```@docs
LaskaCore.clustervector
```

```@docs
LaskaCore.getmeta
```

```@docs
LaskaCore.triggertimes
```

```@docs
LaskaCore.ntrigs
```

### AbstractCluster

```@docs
LaskaCore.AbstractCluster{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`Laska.AbstractCluster`](@ref).

```@docs
LaskaCore.id
LaskaCore.nspikes
LaskaCore.info
LaskaCore.spiketimes
```
## Concrete types

### "Experiment" wrappers

This section describes concrete types for holding entire experiments including their clusters and metadata.

#### PhyOutput

```@docs
LaskaCore.PhyOutput
```

#### RelativeSpikes

```@docs
LaskaCore.RelativeSpikes
```

##### Interfaces

Interfaces only for use with [`LaskaCore.RelativeSpikes`](@ref).

```@docs
LaskaCore.relativespecs
```

```@docs
LaskaCore.stimtimes
```

### Single cluster wrappers

#### Cluster

```@docs
LaskaCore.Cluster
```

#### RelativeCluster

```@docs
LaskaCore.RelativeCluster
```
