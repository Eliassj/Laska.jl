# Installation

All Laska-packages are available from the registry
[LaskaRegistry](https://github.com/Laska-jl/LaskaRegistry).

Adding this registry only has to be done once per Julia installation by running:

```julia
using Pkg

Pkg.Registry.add(RegistrySpec(url="https://github.com/Laska-jl/LaskaRegistry.git"))
```

After adding the registry the packages may be added. Functionality is divided into:

- `LaskaCore.jl`: Functions for importing data, types and their interfaces.
- `LaskaStats.jl`: Functions for calculating stats about clusters such as CV~2~, MAD, frequency over time and analyzing spike trains etc. Reexports `LaskaCore.jl`.
- `LaskaPlot.jl`: Recipes and functions for creating plots. Uses [Makie](https://docs.makie.org/stable/).

Once `LaskaRegistry` has been added, the package(s) may be added like so:

```julia
Pkg.add("LaskaCore")
Pkg.add("LaskaStats")
Pkg.add("LaskaPlot")
```

Once the above has been completed the packages should be ready for use by running:

```julia
using LaskaCore
# and/or
using LaskaStats
# and/or
using LaskaPlot
```
