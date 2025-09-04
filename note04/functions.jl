# utility functions
# const NumericMatrix = AbstractMatrix{<:Union{Int64, Float64}}
# const NumericVector = AbstractVector{<:Union{Int64, Float64}}

dropsum(A; dims=:) = dropdims(sum(A; dims=dims); dims=dims)
nanmean(x) = mean(filter(!isnan, x))
nanmean(x,y) = mapslices(nanmean, x, dims=y)
dropnanmean(x,y) = dropdims(mapslices(nanmean, x, dims=y); dims=y)
nanvar(x) = var(filter(!isnan, x))
nanvar(x,y) = mapslices(nanvar, x, dims=y)
dropnanvar(x,y) = dropdims(mapslices(nanvar, x, dims=y); dims=y)
nanstd(x) = std(filter(!isnan, x))
nanstd(x,y) = mapslices(nanstd, x, dims=y)
dropnanstd(x,y) = dropdims(mapslices(nanstd, x, dims=y); dims=y)

emse(Betas, β) = dropsum(dropnanmean((Betas .- β).^2, 2), dims=1)
emse(Betas::Vector, β) = sum(nanmean((Betas .- β).^2))

evar(Betas) = dropsum(dropnanvar(Betas, 2), dims=1)
evar(Betas::Vector) = sum(nanvar(Betas))

ebiasq(Betas, β) = dropsum((dropnanmean(Betas, 2) .- β).^2, dims=1)
ebiasq(Betas::Vector, β) = sum((nanmean(Betas) .- β).^2)

function calRes(res, θ) 
    mses = emse.(res, Ref(θ))
    vars = evar.(res, Ref(θ))
    bias = ebiasq.(res, Ref(θ))
    return [mses vars bias]
end

# estimators
function getpilot(X, Y, n0)
    N = length(Y)
    idx_poi = sample(1:N, n0, replace=true)
    X_poi, y_poi = X[idx_poi, :], Y[idx_poi]
    par_poi = getEst(X_poi, y_poi)
    p1 = s.(X_poi * par_poi)
    ϕ1 = h.(p1)
    H = inv(X_poi' * (X_poi .* ϕ1) ./ n0)
    V1 = cov(X_poi .* (y_poi .- p1))
    V = H'V1 * H
    A, D, _ = svd(V)
    return par_poi, A, D, H
end

function osmac(X, Y, n0, n; criterion="optA")
    π = calPI(X, Y, n0, n; criterion=criterion)
    idx_opt = wsample(1:N, π, n, replace=true)
    X_opt, y_opt, w_opt = X[idx_opt, :], Y[idx_opt], 1.0 ./ π[idx_opt]
    par_opt = getWEst(X_opt, y_opt, w_opt)
    return par_opt
end

function calPI(X, Y, n0, n; criterion="optA")
    if criterion == "lev"
        U, _, _ = svd(X)
        π = dropsum(U .^ 2, dims=2)
    else
        par_poi, _, _, H = getpilot(X, Y, n0)
        p = s.(X * par_poi)
        if criterion == "optL"
            π = vec(abs.(Y .- p) .* sqrt.(sum(abs2, X, dims=2)))
        elseif criterion == "optA"
            π = vec(abs.(Y .- p) .* sqrt.(sum(abs2, X * H, dims=2)))
        else
            println("Criterion $criterion is not available.")
        end
    end
    normalize!(π, 1)
    return π
end

function iboss(X, Y, n, n0; model="linear")
    if model == "linear"
        @views Z = X[:, 2:end]
    else
        par_poi, _, _, _ = getpilot(X, Y, n0)
        p = s.(X * par_poi)
        Z = sqrt.(h.(p)) .* X
    end
    idx_iboss = getidx_iboss(Z, n)
    x_iboss = X[idx_iboss, :]
    y_iboss = Y[idx_iboss]
    return getEst(x_iboss, y_iboss)
end

# simulation

function simu(θt, case, N, rpt, nss, n0, l_mtds)
    d = length(θt)
    l_nss = length(nss)
    Θ = fill(NaN, d, rpt, l_mtds, l_nss);
    mtd = 0
    Θ_unif = view(Θ, :, :, mtd +=1, :)
    Θ_optA = view(Θ, :, :, mtd +=1, :)
    Θ_optL = view(Θ, :, :, mtd +=1, :)
    Θ_lev = view(Θ, :, :, mtd += 1, :)
    Θ_iboss = view(Θ, :, :, mtd += 1, :)

    Random.seed!(2)
    X, Y = gendat(N, case, θt)

    Θ_f = getEst(X, Y)
    pg = Progress(rpt, 1); spg = isinteractive() # @showprogress
    Threads.@threads for rr in 1:rpt
        for (idn, n) in enumerate(nss)
            Θ_unif[:, rr, idn] .= getpilot(X, Y, n)[1]
            Θ_optA[:, rr, idn] .= osmac(X, Y, n0, n)
            Θ_optL[:, rr, idn] .= osmac(X, Y, n0, n; criterion="optL")
            Θ_lev[:, rr, idn] .= osmac(X, Y, n0, n; criterion="lev")
            Θ_iboss[:, rr, idn] .= iboss(X, Y, n, n0; model=model)
        end
        spg && next!(pg)
    end

    return Θ, Θ_f
end
