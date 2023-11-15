# Laska.jl documentation

```@setup laska
using Laska
```

## Summarizing statistics

### Calculating CV2

```@docs
Laska.cv2(cluster::Laska.Cluster)
```

```@docs
Laska.cv2mean(cluster::Laska.Cluster)
```

### Calculating frequency


```@docs
Laska.frequency(cluster::Laska.Cluster, interval::T) where {T<:Real}
```

# Helpers

## ISI

````@docs
Laska.isi(cluster::Cluster{T}) where {T<:Real}
````


## Spike filtering

### By depth

```@docs
Laska.spikesatdepth(p::Laska.PhyOutput{T}, depth::N) where {T<:Real} where {N<:Real}
```

## Rounding

### roundup()
````@docs
Laska.roundup(value::T, interval::N) where {T<:Real} where {N<:Real}
````
###### Examples
```@repl laska
Laska.roundup(12, 30)
Laska.roundup(12, 23)
Laska.roundup(12.5, 1)
Laska.roundup(12, 3.8)
```
