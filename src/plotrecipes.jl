################################
#
# Recipes for plot types
#
################################

# Rel response plot for depth

@recipe(ResponsePlot) do scene
    Attributes(
        linecolor=:black
    )
end

function MakieCore.plot!(rp::Laska.ResponsePlot{<:Tuple{Laska.relativeSpikes,Int64,Int64}})
    r = relresponse(rp[1][], rp[2][], depthbaseline(rp[1][]), rp[3][])
    depthsval::Vector{Float64} = [minimum(r[:, 1]) * i for i in 1:rp[3][]]
    i::Int64 = 1
    for key in depthsval
        data = r[findall(x -> x == key, r[:, 1]), :]
        #data[:, 4] = [hash(data[n, 1], hash(data[n, 2])) for n in eachindex(data[:, 1])] # To sum by time and depth interval
        lines!(rp, data[:, 2] ./ 30, data[:, 3] .- i)
        i += 1
    end

    rp
end
