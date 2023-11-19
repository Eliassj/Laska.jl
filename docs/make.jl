using Documenter, Laska


makedocs(
    sitename="Laska Documentation",
    pages=[
        "Home" => "index.md",
        "Guide" => ["guide/importing.md"],
        "Reference" => [
            "Importing data" => "ref/import.md",
            "Summarizing" => "ref/summarize.md",
            "Visualize" => "ref/visualize.md"
        ]
    ]
)

deploydocs(
    repo="github.com/Eliassj/Laska.jl.git"
)
