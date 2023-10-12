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

function fakephy(spiketimes::Matrix{Float64})
    nafilter = findall(x -> x.!= NaN, spiketimes[:,2])
    intspiketimes::Matrix{Int64} = hcat(Int64.(spiketimes[nafilter,1]), Int64.(round.(spiketimes[nafilter,2] .* 40000)))
    info = DataFrame(
        cluster_id = collect(Set(intspiketimes[:,1]))
    )
    meta = Dict{SubString{String}, SubString{String}}()
    meta["imSampRate"] = "40000"
    binpath = ""
    trigs = nothing
    return PhyOutput(
        intspiketimes,
        info,
        meta,
        binpath,
        trigs
    )
end
