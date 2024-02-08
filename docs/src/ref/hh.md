# Modeling

## Hodgkin-Huxley model

### Model containers

```@docs
LaskaML.hh.HHModel
```

##### Examples

### Ion channels

#### Generalized ion channel struct

```@docs
LaskaML.hh.HHChannel
```

```@docs
LaskaML.hh.hhchannel
```

###### Interface functions

Functions for accessing the fields of `HHChannel`

```@docs
LaskaML.hh.id
LaskaML.hh.conductance
LaskaML.hh.alpha_m
LaskaML.hh.beta_m
LaskaML.hh.m_exponent
LaskaML.hh.alpha_h
LaskaML.hh.beta_h
LaskaML.hh.h_exponent
```

#### Expression constructors

The following functions are used to turn `HHChannel` structs into `String`s representing their mathematical expression.

```@docs
LaskaML.hh.parsechannel
```

### α and β functions

#### Generalized version

```@docs
LaskaML.hh.ab_generalized
```

A generalized version of the α/β functions as per [Nelson, M.E. (2004)](http://nelson.beckman.illinois.edu/courses/physl317/part1/Lec3_HHsection.pdf)

Calculated as:

```math
\alpha(V) = \frac{A + BV}{C+Hexp(\frac{V+D}{F})}
```
