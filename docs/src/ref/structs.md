# Structs and their Interfaces


## Abstract types

### AbstractExperiment

```@docs
AbstractExperiment{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`AbstractExperiment`](@ref).

```@docs
clusterids
```

```@docs
getcluster
```

```@docs
clustervector
```

```@docs
getmeta
```

```@docs
triggertimes
```

```@docs
ntrigs
```

### AbstractCluster

```@docs
AbstractCluster{T}
```

##### Interfaces

The following functions provide interfaces to all structs that are children of [`Laska.AbstractCluster`](@ref).

```@docs
nspikes
info
spiketimes
```
## Concrete types

### "Experiment" wrappers

This section describes concrete types for holding entire experiments including their clusters and metadata.

#### PhyOutput

```@docs
PhyOutput
```

#### RelativeSpikes

```@docs
RelativeSpikes
```

##### Interfaces

Interfaces only for use with [`RelativeSpikes`](@ref).

```@docs
relativespecs
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
