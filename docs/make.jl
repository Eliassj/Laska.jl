using Documenter, Laska


makedocs(
    sitename="Laska Documentation",
    pages=[
        "Home" => "index.md",
        "Guide" => ["guide/importing.md"],
        "Reference" => [
            "Structs & their interfaces" => "ref/structs.md",
            "Importing data" => "ref/import.md",
            "Filter data" => "ref/filters.md",
            "Summarizing" => "ref/summarize.md",
            "Visualize" => "ref/visualize.md",
            "Helpers" => "ref/helpers.md"
        ]
    ]
)

deploydocs(
    repo="github.com/Eliassj/Laska.jl.git"
)
