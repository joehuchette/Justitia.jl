using Justitia
using Documenter

makedocs(;
    sitename="Justitia.jl",
    authors="Joey Huchette",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        # canonical="https://joehuchette.github.io/Justitia.jl",
        assets=String[],
    ),
    repo="https://github.com/joehuchette/Justitia.jl/blob/{commit}{path}#L{line}",
    modules=[Justitia],
    pages=[
        "Home" => "index.md",
        "User guide" => [
            "Interface" => "manual/interface.md",
            "Included implementations" => "manual/implementations.md",
        ],
        # "Reference" => "reference/reference.md",
    ],
)

deploydocs(
    repo="github.com/joehuchette/Justitia.jl.git",
)
