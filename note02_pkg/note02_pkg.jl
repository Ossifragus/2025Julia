#' # Use packages and setup project
#' Pkg is Julia's builtin package manager
using Pkg
#' Active the project at current directory.
Pkg.activate(".")

#' Add packages using `Pkg.add`, or in the pkg mode,
#' or just using the package.

#+ eval=false
Pkg.add("Example") # Add a package from registry
Pkg.add(name="Example", version="0.3.1") # Specify version; exact release

#+ eval=true
x = collect(1:10)
y = log.(x)

#' ## Statistics
using Statistics

#' Calculate the sample mean (average)
mean(x)

#' Calculate the sample standard deviation
std(x)
 
#' Calculate the correlation of x and y
cor(x, y)

#' Compute the median of x
median(x)

#' Compute the 90th percentile of x
quantile(x, 0.9)

#' compute the 0th, 25th, 50th, 75th, 100th percentiles of x
quantile(x, [0.0, 0.25, 0.5, 0.75, 1.0])

#' ## Importing and Exporting data in delimited format

using DelimitedFiles
#' Make sure the data is in the working directory, or you can change the directory to where the data is saved, using `cd(path)`. 
#' For Mac and Linux, use this format 
#' `path = "/home/ossifragus/Dropbox/teaching/julia"`; 
#' for Windows, use this format 
#' `path = "c:\\Users\\ossifragus\\Dropbox\\teaching\\julia"`. 
dat = readdlm("USairpollution.csv", ',')
dat = readdlm("USairpollution.csv", ',', Any, '\n')
dat, header = readdlm("USairpollution.csv", ',', header=true)
dat = readdlm("USairpollution.csv", ',', skipstart=10)

#' The complete director can also be used.
dat = readdlm("/home/ossifragus/Insync/OneDrive/teaching/julia2025/note02_pkg/USairpollution.csv", ',', skipstart=1)

#' Export dat
writedlm("dataNew.csv", dat, ",")
writedlm("dataNew.csv", dat)

#' ### DataFrames
#' `DataFrams` and `CSV` are very useful packages.
#' Run the following code for the first time to install these packages.
#+ eval=false
Pkg.add("DataFrames")
Pkg.add("CSV")
#' It needs precompiling for the first time use.
using DataFrames, CSV
dat1 = CSV.read("USairpollution.csv", DataFrame)
#' Export dat
CSV.write("data1.csv", dat1)

#' ## Random number generation
#' rand is the base random generation function.
using Random, Distributions # load packages
Random.seed!(2025) # set seed of random
#' Generate a 10 by 1 vector of random numbers from U(0, 1)
rand()
rand(10)
#' Generate a 3 by 4 matrix of random numbers from U(0, 1)
rand(3, 4)
#' Generate a 3 by 4 matrix of random numbers from N(0, 1)
randn(3, 4)
#' Generate a 3 by 4 matrix of random numbers from EXP(1)
randexp(3, 4)

#' A convention in Julia: appending ! to names of functions that modify their arguments.
a = rand(1:9, 9)
sort(a)
sort!(a)

#' Use the Distributions package, we can define various distributions and generate randoms from them. For example, generate 100 data points from $N(\mu=0, \sigma^2=2^2)$.
d = Normal(0, 2)
x = rand(d, 100)
#' Check the mean and standard deviation
(mean(x), std(x))

#' Generate 10 data points from multivariate normal distribution $N\bigg\{\mu=\binom{0}{3}, \Sigma=\begin{pmatrix}1&2\\2&5\end{pmatrix}\bigg\}$. Note that julia support unicode variables (https://docs.julialang.org/en/v1/manual/unicode-input/).
μ = [0; 9]
Σ = [1.0 2; 2 5]
mvn = MvNormal(μ, Σ)
x = rand(mvn, 1000)
#' Check the sample mean vector
mean(x, dims=2)
#' and the sample covariance matrix
# cov(x')
cov(x, dims=2)

#' ## Plot
#' Create a histogram. The first plot takes a long time. 
using Plots
histogram(x[1, :])
#' Plot the two components of x.
plot(x')
#' Create a scatter plot
plot(x[1, :], x[2, :], seriestype=:scatter)
scatter(x[1, :], x[2, :])

using FLoops
function findS_F(ρ, p)
    S = 0 
    @floop for i in 1:p, j in 1:p
        @reduce(S += ρ^abs(i-j))
    end
    return S
end

ρ, p = 0.5, 10000
@time findS_F(ρ, p)

# Threads.nthreads()
# export JULIA_NUM_THREADS=4

# using LinearAlgebra
# BLAS.set_num_threads(1)
# ccall((:openblas_get_num_threads64_, Base.libblas_name), Cint, ())

#' ## Interact with R using the RCall package
#+ eval=false
using Pkg
Pkg.add("RCall")
#+ eval=true
using RCall
#' After loading the package, in julia REPL, press $ to activate the R REPL mode and the R prompt will be shown; press backspace to leave R REPL mode. 

#' Generate data from a linear model
using Random
n = 10
X = randn(n, 2)
β = [2.0, 3.0]
y = X * β .+ randn(n)
#' Calculate the least square estimate using
β̂ = X'X \ X'y # it calculates inv(X' * X) * (X' * y)

#' Note that X and y are julia variables. @rput sends y and X to R with the same names
@rput y
@rput X

#' Fit a model in R
R"mod <- lm(y ~ X-1)"
R"summary(mod)"

#' You can have multiple lines of R code
R"""
mod2 = lm(y~X)
summary(mod2)
"""

#' To retrieve a variable from R, use @rget. For example,
R"z <- y * 3"
@rget z

#+ eval=false; echo = false; results = "hidden"
using Weave

set_chunk_defaults!(:term => true)
weave("note02_pkg.jl", cache=:off)

# ENV["GKSwstype"]="nul"
# get_chunk_defaults()
# set_chunk_defaults!(:term => true)
# weave("basic_grammar.jl", cache=:off, doctype="github", out_path="output/")
# ENV["GKSwstype"]="gksqt"
