s(x) = x
h(x) = 1.0

function getEst(x, y)
    return x'x \ x'y
end

function getWEst(x, y, w)
    xw = x .* w
    return xw'x \ xw'y
end
