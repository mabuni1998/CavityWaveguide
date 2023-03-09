push!(LOAD_PATH,"../src/")

using Documenter
using DocumenterCitations
using CavityWaveguide

DocMeta.setdocmeta!(CavityWaveguide, :DocTestSetup, :(using CavityWaveguide); recursive=true)

bib = CitationBibliography(joinpath(@__DIR__,"src/references.bib"))

makedocs(
bib,
doctest = false,
clean = true,
sitename = "CavityWaveguide.jl",
format = Documenter.HTML(),
modules = [CavityWaveguide],
authors = "Matias Bundgaard-Nielsen",
pages = [
"CavityWaveguide.jl" => "index.md",
"Toturials" => ["Continous Fock States" => "continous_fockstates.md"],
"Examples" => ["Beamsplitter" => "detection_example.md"],
"API" => "API.md",
"References" => "references.md",
]
)

deploydocs(
    repo = "github.com/mabuni1998/CavityWaveguide.git"
)
