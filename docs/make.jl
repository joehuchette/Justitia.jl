using Justitia
using Documenter

makedocs(;
    modules = [Justitia],
    authors = "Joey Huchette",
    repo = "https://github.com/joehuchette/Justitia.jl/blob/{commit}{path}#L{line}",
    sitename = "Justitia.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://joehuchette.github.io/Justitia.jl",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "User guide" => [
            "Interface" => "manual/interface.md",
            "Included implementations" => "manual/implementations.md",
        ],
        # "Reference" => "reference/reference.md",
    ],
)

deploydocs(; repo = "github.com/joehuchette/Justitia.jl")
