# Helpers

This section describes general helper functions that does not fit under other, more specific headings.


```@setup laska
using Laska
```

# Helpers

## Rounding

Functions for "rounding" numbers to arbitrary intervals.

```@docs
LaskaCore.roundup
```

###### Examples

```@repl laska
LaskaCore.roundup(12, 30)
LaskaCore.roundup(12, 23)
LaskaCore.roundup(12.5, 1)
LaskaCore.roundup(17, 3.8)
```

```@docs
LaskaCore.rounddown
```

###### Examples

```@repl laska
LaskaCore.rounddown(12, 30)
LaskaCore.rounddown(12, 23)
LaskaCore.rounddown(12.5, 1)
LaskaCore.rounddown(17, 3.8)
```

```@docs
LaskaCore.arbitraryround
```

###### Examples

```@repl laska
LaskaCore.arbitraryround(12, 30)
LaskaCore.arbitraryround(12, 23)
LaskaCore.arbitraryround(12.5, 1)
LaskaCore.arbitraryround(17, 3.8)
```

## Unit conversions

Functions for converting between different units.

### Time

```docs
LaskaCore.mstosamplerate
LaskaCore.sampleratetoms
```
