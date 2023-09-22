using MAT

const matpath = "/run/media/elias/T7/Singleunits.mat"

function importsingleunits(path::String)
    return matread(path)
end

function reshape2long(matr::Matrix{Float64})
    out = Matrix{Float64}(undef, (size(matr, 1) * size(matr, 2) - count(isnan, matr), 2))
    id = 1
    n = 1
    for row in eachrow(matr)
        for val in row
            if isnan(val)
                continue
            end
            out[n, :] = [id val]
            n += 1
        end
        id += 1
    end
    return out
end


