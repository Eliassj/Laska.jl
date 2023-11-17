using Documenter, Laska


makedocs(
    sitename="Laska Documentation",
    pages=[
        "Home" => "index.md",
        "Reference" => [
            "Importing data" => "ref/import.md",
            "Summarizing" => "ref/summarize.md"
        ]
    ]
)

deploydocs(
    repo="github.com/Eliassj/Laska.jl.git"
)
