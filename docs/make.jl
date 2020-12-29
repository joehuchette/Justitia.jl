using Justitia
using Documenter

makedocs(;
    sitename="Justitia.jl",
    authors="Joey Huchette",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        assets=String[],
    ),
    modules=[Justitia],
    pages=[
        "Home" => "index.md",
        "User guide" => [
            "Interface" => "manual/interface.md",
            "Included implementations" => "manual/implementations.md",
        ],
    ],
)

deploydocs(
    repo="github.com/joehuchette/Justitia.jl.git",
    devbranch="main",
)
