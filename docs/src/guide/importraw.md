# Importing raw Neuropixels data

Importing raw channels as recorded with the Neuropixels probes may be done with the
[`LaskaCore.importglx`](@ref) function. In order to read the file correctly some information
such as the total number of channels in the recording is required. This is most easily provided
by passing a parsed SpikeGLX .meta file to the function.

```julia
meta = LaskaCore.parseglxmeta("/path/to/metafile.ap.meta")

data_raw = LaskaCore.importglx("path/to/raw/data.ap.bin",
                               1:320, # Channel indices to include
                               60_000:120_000, # Time indices to include
                               meta)

```

In the example above, we first import and parse a .meta file using the `parseglxmeta` function.
Parsed GLX meta may also be obtained from a `PhyOutput` or `RelativeSpikes` struct using the
[`LaskaCore.getmeta`](@ref) function if a path to the meta file was provided when creating
the `PhyOutput`. We then call the `importglx` function with the path to the raw data, the channels
we would like to import and the time _indices_ to include. In this case, assuming that the
samplerate is 30000Hz we import seconds 2--4 of the recording. If all channels or times are to
be included, replace either argument with `:`.

The `Matrix` returned from `importglx` will contain an analog representation of the voltage
for each channel (rows) at each time (columns). The formula for converting these values to volts
depends on the type of probe and settings used when recording. LaskaCore provides the [`LaskaCore.tovolts`](@ref)
function for easy conversion using information found in the same meta file as used when first importing the data.

```julia
data_volts = LaskaCore.tovolts(data_raw, meta)
```
