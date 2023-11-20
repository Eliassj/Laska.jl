# Types and their interfaces

## Abstract types

### AbstractExperiment

```@docs
Laska.AbstractExperiment{T}
```

#### Interfaces

The following functions provide interfaces to all structs that are children of `AbstractExperiment`.

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

#### Interfaces

The following functions provide interfaces to all structs that are children of [`AbstractCluster`](@ref).

```@docs
Laska.id
```

```@docs
Laska.nspikes
```

```@docs
Laska.info
```

```@docs
Laska.spiketimes
```
## Concrete types

### "Experiment" wrappers

#### PhyOutput

```@docs
Laska.PhyOutput
```

### Single cluster wrappers

#### Cluster

```@docs
Laska.Cluster
```
