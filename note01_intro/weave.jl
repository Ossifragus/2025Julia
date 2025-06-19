#+ eval=false; echo = false; results = "hidden"
using Weave

set_chunk_defaults!(:term => true)
weave("basic_grammar.jl", cache=:off)

weave("basic_grammar.jl", cache=:off, doctype="github", out_path="output/")

# ENV["GKSwstype"]="nul"
# get_chunk_defaults()
# set_chunk_defaults!(:term => true)
# weave("note02_intro_julia.jl", cache=:off)
# ENV["GKSwstype"]="gksqt"
