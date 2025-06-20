s(x) = 1.0 / (1.0 + exp(-x))
h(x) = x * (1.0 - x)

function pred!(X, β, p)
    mul!(p, X, β)
    p .= s.(p)
end

function pred!(X, β, π, p)
    mul!(p, X, β)
    p .= 1.0 ./ (1.0 .+ exp.(.- p) .* π)
end

function getEst(x, y)
    (n, d) = size(x)
    beta = zeros(d, 1)
    shs = similar(beta)
    beta_new = similar(beta)
    p = Array{Float64}(undef, n, 1)
    S = similar(x)
    xs = similar(x)
    H = Array{Float64}(undef, d, d)
    ss = Array{Float64}(undef, 1, d)
    loop = 1;
    Loop = 100;
    msg = "NA";
    while loop <= Loop
        pred!(x, beta, p)
        S .= x .* (y .- p)
        ss = sum(S, dims=1)
        xs .= x .* p .* (1.0 .- p)
        mul!(H, x', xs)
        try
            # ldiv!(shs, qr(H), ss')
            shs = H \ ss'
        catch
            msg = "H is singular"; println(msg)
            beta .= NaN
            break
        end
        beta_new .= beta .+ shs
        tlr  = sum(abs2, shs)
        beta .= beta_new
        if tlr < 0.000001
            msg = "Successful convergence"
            break
        end
        if loop == Loop
            msg = "Maximum iteration reached"; println(msg)
            beta .= NaN
            break
        end
        loop += 1
    end
    return vec(beta) #, msg, loop, H, S'S
end

function getWEst(x, y, w)
    (n, d) = size(x)
    beta = zeros(Float64, d, 1)
    shs = similar(beta)
    beta_new = similar(beta)
    p = Array{Float64}(undef, n, 1)
    S = similar(x)
    xs = similar(x)
    H = Array{Float64}(undef, d, d)
    ss = Array{Float64}(undef, 1, d)
    loop = 1;
    Loop = 100;
    msg = "NA";
    wx = similar(x)
    wx .= w .* x ####################################### weighted x
    while loop <= Loop
        pred!(x, beta, p)
        S .= wx .* (y .- p)         ######################## use weighted x
        ss = sum(S, dims=1)
        xs .= wx .* p .* (1.0 .- p) ######################## use weighted x
        mul!(H, x', xs)
        # H .+= 0.001
        try
            # ldiv!(shs, qr(H), ss')
            shs = H \ ss'
        catch
            msg = "H is singular"; println(msg)
            beta .= NaN
            break
        end
        beta_new .= beta .+ shs
        tlr  = sum(shs.^2)
        beta .= beta_new
        if tlr < 0.000001
            msg = "Successful convergence"
            break
        end
        if loop == Loop
            msg = "Maximum iteration reached"; println(msg)
            beta .= NaN
            break
        end
        loop += 1
    end
    return vec(beta) #, msg, loop, H, S'S
end
