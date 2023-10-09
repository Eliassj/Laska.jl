function responseplot(t::relativeSpikes, period::Int64, depthdiv::Int64=4)
    r = relresponse(t, period, depthbaseline(t), depthdiv)
    depthsval::Vector{Float64} = [minimum(r[:, 1]) * i for i in 1:depthdiv]
    fig = Figure()
    axv = Vector{Axis}(undef, depthdiv)
    for n in 1:depthdiv
        axv[n] = Axis(fig[n, 1])
    end
    for (i, key) in enumerate(depthsval)
        data = r[findall(x -> x == key, r[:, 1]), :]
        #data[:, 4] = [hash(data[n, 1], hash(data[n, 2])) for n in eachindex(data[:, 1])] # To sum by time and depth interval
        lines!(axv[i], data[:, 2] ./ 30, data[:, 3])
    end

    display(fig)
end
