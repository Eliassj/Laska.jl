#Pkg.Registry.add(RegistrySpec(url="https://github.com/Laska-jl/LaskaRegistry.git"))

#Pkg.add("LaskaCore")
#Pkg.add("LaskaStats")
#Pkg.add("LaskaPlot")
#Pkg.add("Laska")

using Documenter, Laska



makedocs(
    sitename="Laska Documentation",
    pages=[
        "Home" => "index.md",
        "Guide" => [
            "guide/install.md",
            "guide/importing.md"
        ],
        "Reference" => [
            "Structs & their interfaces" => "ref/structs.md",
            "Importing data" => "ref/import.md",
            "Filter data" => "ref/filters.md",
            "Trigger events" => "ref/triggers.md",
            "Summarizing" => "ref/summarize.md",
            "Visualize" => "ref/visualize.md",
            "Helpers" => "ref/helpers.md"
        ]
    ]
)

deploydocs(
    repo="github.com/Laska-jl/Laska.jl.git"
)
