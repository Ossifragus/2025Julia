function getidx_iboss(x, k)
    (n,p) = size(x)
    idx = Array{Int64}(undef, k)
    counter = 1
    r = cld(k, 2p)
    tmp2 = x[:,1]
    l = sort!(tmp2; alg=PartialQuickSort(r))[r]
    u = sort!(tmp2; alg=PartialQuickSort(r), rev=true)[r]
    bl = 1; bu = 1;
    for s in 1:n
        # global counter
        if bl > r && bu > r
            break
        elseif bl <= r && x[s,1] <= l
            idx[counter] = s
            counter += 1
            bl += 1
        elseif bu <= r && x[s,1] >= u
            idx[counter] = s
            counter += 1
            bu += 1
        end
    end
    for j in 2:p
        tl = n - counter + 1
        tmp = Vector{Float64}(undef, tl)
        t = 1; v = 1;
        for s in 1:n
            # global v, t
            if s != idx[v]
                tmp[t] = x[s,j]
                t += 1
            elseif v < counter - 1
                v += 1
            end
        end
        l = sort!(tmp; alg=PartialQuickSort(r))[r]
        u = sort!(tmp; alg=PartialQuickSort(r), rev=true)[r]
        v = 1; bl = 1; bu = 1;
        for s in 1:n
            # global v, k, counter
            if counter > k || (bl > r && bu > r)
                break
            elseif v < counter && s == idx[v]
                v += 1
            elseif bl <= r && x[s,j] <= l
                idx[v+1:counter] = idx[v:counter-1]
                idx[v] = s
                v += 1
                counter += 1
                bl += 1
            elseif bu <= r && x[s,j] >= u
                idx[v+1:counter] = idx[v:counter-1]
                idx[v] = s
                v += 1
                counter += 1
                bu += 1
            end
        end
    end
    return idx
end
