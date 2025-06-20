using Pkg; Pkg.activate(".")
using Statistics, BSON, Revise
using Plots
# ------------------------------------------------------------------
includet("functions.jl")

# mtds = ["uni", "optA", "optL", "lev", "iboss"];
# nss = [200, 500, 800, 1000]

models = ["linear", "logistic"]
cases = [1, 2]
PTs = []

for model in models, case in cases
    fn = joinpath(model, "output", "$(model)-case$(case)")
    BSON.@load fn * ".bson" res θt θf mtds nss
    logmse = log.(emse(res, θf)')
    pt = plot(nss, logmse, lw=3, markersize=12, ls=:auto,
              markershape=[:circle :rect :star5 :diamond :hexagon], 
              tickfontsize=16, xguidefontsize=18, yguidefontsize=18,
              legendfontsize=18, grid=false, thinkness_scaling=1,
              label=permutedims(mtds), xlab="n", ylab="log(eMSE)", 
              legend=:topright,
              sizes = (800,600))
    savefig(pt, fn * "-Plots.pdf")
    # push!(PTs, pt)
end

# plot(PTs[1], PTs[2], link=true)


    # isinteractive() || 
    #     run(`cp $(fn * "sep.tex") ../draft/tables`)

using CairoMakie

for model in models, case in cases
    fn = joinpath(model, "output", "$(model)-case$(case)")
    BSON.@load fn * ".bson" res θt θf mtds nss
    logmse = log.(emse(res, θf)')
    tp = [1, 2, 4, 5]
    mks = '1':'7'
    cls = [:orangered4, :red, :blue, :orange, :darkorange]
    f = Figure(size=0.7 .* (800, 600));
    ax = f[1, 1] = Axis(f, xlabel=L"n", ylabel="log(eMSE)") #, yscale=log10)
    # hidedecorations!(ax, label=false, ticklabels=false, ticks=false)
    for (i, tm) in enumerate(tp)
        scatterlines!(nss, (logmse[:,tm]), marker=mks[i], color=cls[i],
                      markersize=20, label=mtds[i])
    end
    # f[1, 2] = Legend(f, ax, "Methods", framevisible=false)
    axislegend(position=:rt, padding=2 .*(1, 1, 1, 1))
    save(fn * ".pdf", f)
end
