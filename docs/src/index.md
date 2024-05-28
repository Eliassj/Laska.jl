```@raw html
---
layout: home

hero:
  name: "Laska.jl"
  text: "Analyze Neuropixels data"
  tagline: A Julia package for analyzing and visualizing Neuropixels data.
  image:
    src: /logo.png
    alt: Laska.jl
  actions:
    - theme: brand
      text: Installation
      link: /guide/install
    - theme: alt
      text: Importing data
      link: /guide/importing
    - theme: alt
      text: LaskaCore
      link: /ref/core_ref
    - theme: alt
      text: LaskaStats
      link: /ref/stat_ref
    - theme: alt
      text: LaskaPlot
      link: /ref/plot_ref
---
```

# Laska.jl documentation

Welcome to the WIP documentation for the WIP package Laska.jl.

Laska.jl provides functions for importing, manipulating and visualizing
data obtained from Neuropixels probes using spikeGLX and preprocessed in KiloSort and Phy.

The package is currently divided into:

- **LaskaCore**: Types, importing data, basic summary statistics
- **LaskaStats:** Summary statistics and similar.
- **LaskaPlot:** Plotting functions using Makie.

Importing `Laska` will include all of the above and reexport their functions.
