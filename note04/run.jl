initime = time()
using Pkg; Pkg.activate(".")
# Pkg.instantiate() # run this line to instantiate the project one time
using Random, LinearAlgebra, Statistics
using StatsBase, Revise, ProgressMeter, BSON, PrettyTables
BLAS.set_num_threads(1)

model = haskey(ENV, "model") ? ENV["model"] : "linear"
case = haskey(ENV, "case") ? parse(Int, ENV["case"]) : 1

includet("functions.jl")
includet("getidx_iboss.jl")
includet(joinpath(model, "gendat.jl"))
includet(joinpath(model, "estimators.jl"))
# includet("linear/gendat.jl")
# includet("linear/estimators.jl")

savepath = joinpath(model, "output")
fn = joinpath(savepath, "$(model)-case$(case)")
!all(ispath(savepath)) && mkpath(savepath)

N = 10^5
θt = [0.5, 0.5, -0.5, 0.5, -0.5]
mtds = ["uni", "optA", "optL", "lev", "iboss"];
l_mtds = length(mtds)
header=[:n; mtds]
n0 = 200
nss = [200, 500, 800, 1000]

rpt = 10;
Random.seed!(2);
@time res, θf = simu(θt, case, N, rpt, nss, n0, l_mtds);
BSON.@save fn * ".bson" res θf θt mtds nss
# BSON.@load fn * ".bson" res θt

rec = [nss round.(emse(res, θf), digits=4)']
pretty_table(rec, header=header, formatters=ft_printf("%5.3f", 1 .+ (1:l_mtds)))

# save_temp_results()
@show (time() - initime) / 60

# chk = round(sum(abs, emse(res, θt)), digits=12)
# shouldbe = Dict([("linear",   0.164594732532),
#                  ("logistic", 1.143399776076)])
# @assert chk == shouldbe[model] "results changed"
