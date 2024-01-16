# Modelling

## Hodgkin-Huxley model

### Ion channels

#### Generalized ion channel

```@docs
LaskaML.hh.HHChannel
```

### α and β functions

#### Generalized version

```@docs
LaskaML.ab_generalized
```

A generalized version of the α/β functions as per [Nelson, M.E. (2004)](http://nelson.beckman.illinois.edu/courses/physl317/part1/Lec3_HHsection.pdf)

Calculated as:

```math
\alpha(V) = \frac{A + BV}{C+Hexp(\frac{V+D}{F})}
```
