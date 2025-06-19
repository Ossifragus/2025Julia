using Pkg
Pkg.activate(".")

using DataFrames
using Arrow, CSV, JDF

bigdf = DataFrame(rand(Bool, 10^5, 1000), :auto)
bigdf[!, 1] = Int.(bigdf[!, 1])
bigdf[!, 2] = bigdf[!, 2] .+ 0.5
bigdf[!, 3] = string.(bigdf[!, 3], ", as string")

println("First run")
csvwrite1 = @elapsed @time CSV.write("bigdf1.csv", bigdf)
jdfwrite1 = @elapsed @time JDF.save("bigdf.jdf", bigdf)
arrowwrite1 = @elapsed @time Arrow.write("bigdf.arrow", bigdf)

println("Second run")
csvwrite2 = @elapsed @time CSV.write("bigdf1.csv", bigdf)
jdfwrite2 = @elapsed @time JDF.save("bigdf.jdf", bigdf)
arrowwrite2 = @elapsed @time Arrow.write("bigdf.arrow", bigdf)

println("First run")
csvread1 = @elapsed @time CSV.read("bigdf1.csv", DataFrame)
jdfread1 = @elapsed @time JDF.load("bigdf.jdf") |> DataFrame
arrowread1 = @elapsed @time df_tmp = Arrow.Table("bigdf.arrow") |> DataFrame
arrowread1copy = @elapsed @time copy(df_tmp)

println("Second run")
csvread2 = @elapsed @time CSV.read("bigdf1.csv", DataFrame)
jdfread2 = @elapsed @time JDF.load("bigdf.jdf") |> DataFrame
arrowread2 = @elapsed @time df_tmp = Arrow.Table("bigdf.arrow") |> DataFrame
arrowread2copy = @elapsed @time copy(df_tmp)

#+ eval=false; echo = false; results = "hidden"
using Weave
set_chunk_defaults!(:term => true)
# ENV["GKSwstype"]="nul"
weave("package.jl")
