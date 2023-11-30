# Installation

All Laska-packages are available from the registry
[LaskaRegistry](https://github.com/Laska-jl/LaskaRegistry).

Adding this registry only has to be done once per Julia installation by running:

```@repl
using Pkg

Pkg.Registry.add(RegistrySpec(url="https://github.com/Laska-jl/LaskaRegistry.git"))
```

After adding the registry the packages may be added. Functionality is divided into:

- LaskaCore.jl: Functions for importing data, types and their interfaces as well as some unexported helper functions.
- LaskaStats.jl: Functions for calculating stats about clusters such as CV~2~, MAD, frequency over time etc. Reexports LaskaCore.jl
- LaskaPlot.jl: Recipes and functions for creating basic plots. Uses [Makie](https://docs.makie.org/stable/). Reexports both LaskaCore.jl and LaskaStats.jl.
- Laska.jl: Includes all of the above packages and reexports their functions.

Once `LaskaRegistry` has been added, the package(s) may be added like so:

Add all functionality:

```@repl
Pkg.add("Laska")
```

...or add only the functionality you need:

```@repl
Pkg.add("LaskaCore")
Pkg.add("LaskaStats")
Pkg.add("LaskaPlot") # Currently not functionally different from adding Laska.
```
