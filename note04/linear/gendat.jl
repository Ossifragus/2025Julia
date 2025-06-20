# set up the unknown parameters
function setPar(case, dθ)
    σ = 1
    if case ∈ 1:4
        θ = -0.5ones(dθ)
        α =  [-5; -ones(dθ-1); 1]
        α = copy(θ) 
    end
    return θ, σ, α
end

function gendat(N, case, θ)
    X = Array{Float64}(undef, N, length(θ))
    Y = Vector{Float64}(undef, N)
    view(X, :, 1) .= 1
    genX!(case, X)
    genY!(θ, X, Y)
    return X, Y
end

function genX!(case, X)
    N, d = size(X)
    dz = d - 1
    ρ  = 0.5
    Σx = ρ.^abs.((1:dz) .- (1:dz)')
    # σ = 1 ./ sqrt.(1:dz); Σx = σ .* Σx .* σ'
    _,sig = cholesky(Σx)
    Z = view(X, :, 2:d)
    if case == 1 # independent normal μ=0
        Z .= randn.()
    elseif case == 2 # independent normal μ≠0
        Z .= 2.0 .+ randn.();
    elseif case == 3 # dependent normal μ=0
        Z .= randn.();
        rmul!(Z, sig)
    elseif case == 4 # exp
        Z .= randexp.();
    elseif case == 5 # T with variance 1
        Z .= randn.()
        rmul!(Z, sig)
        df = 3.0
        Z .= Z ./ sqrt.(rand.(Chisq(df)) ./ (df - 2.0))
    end
end

function genY!(θ, X, Y)
    d = size(X, 2)
    Z = view(X, :, 2:d)
    η = Array{Float64}(undef, length(Y))
    mul!(η, Z, θ[2:end])
    η .+= θ[1]
    Y .= η .+ randn.()
end
