# Helpers

This section describes general helper functions that does not fit under other, more specific headings.

```@contents
```

```@setup laska
using Laska
```

# Helpers

## Rounding

Functions for "rounding" numbers to arbitrary intervals.

```@docs
Laska.roundup
```

###### Examples

```@repl laska
Laska.roundup(12, 30)
Laska.roundup(12, 23)
Laska.roundup(12.5, 1)
Laska.roundup(17, 3.8)
```

```@docs
Laska.rounddown
```

###### Examples

```@repl laska
Laska.rounddown(12, 30)
Laska.rounddown(12, 23)
Laska.rounddown(12.5, 1)
Laska.rounddown(17, 3.8)
```

```@docs
Laska.arbitraryround
```

###### Examples

```@repl laska
Laska.arbitraryround(12, 30)
Laska.arbitraryround(12, 23)
Laska.arbitraryround(12.5, 1)
Laska.arbitraryround(17, 3.8)
```

## Unit conversions

Functions for converting between different units.

### Time

```docs
Laska.mstosamplerate
Laska.sampleratetoms
```
