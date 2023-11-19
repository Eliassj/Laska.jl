# Laska.jl documentation

```@setup laska
using Laska
```

## Summarizing statistics

### Calculating frequency



# Helpers

## ISI

````@docs
Laska.isi(cluster::Laska.Cluster{T}) where {T<:Real}
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
