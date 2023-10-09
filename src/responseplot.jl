function responseplot(t::relativeSpikes, period::Int64, depthdiv::Int64=4)
    r = relresponse(t, period, depthbaseline(t), depthdiv)
    depthsval::Vector{Float64} = [minimum(r[:, 1]) * i for i in 1:depthdiv]
    fig = Figure()
    axv = Vector{Axis}(undef, depthdiv)
    xts = append!(append!([-t._specs["back"]], values(t._stimulations)), t._specs["forward"])
    # Create axes
    for n in 1:depthdiv
        if n < depthdiv
            axv[n] = Axis(
                fig[n, 1],
                xticks=xts,
                xticksvisible=false,
                xticklabelsvisible=false,
                xgridwidth=2.0,
                yticklabelsvisible=false,
                yticksvisible=false,
                yticks=[1.0],
                ylabel=string(Int(depthsval[1]) * (n - 1)) * " - " * string(Int(depthsval[1]) * n) * " µm",
                ylabelrotation=π * 2
            )
            hidespines!(axv[n])
        else
            axv[n] = Axis(
                fig[n, 1],
                xticks=(xts),
                xgridwidth=2.0,
                yticklabelsvisible=false,
                yticksvisible=false,
                yticks=[1.0],
                ylabel=string(Int(depthsval[1]) * (n - 1)) * " - " * string(Int(depthsval[1]) * n) * " µm",
                ylabelrotation=π * 2
            )
            hidespines!(axv[n], :t, :r, :l)
        end
    end
    if depthdiv > 1
        linkaxes!(axv[1], axv[2:end])
        for ax in axv[1:end-1]
            hidespines!(ax, :b)
        end
    end
    for (i, key) in enumerate(depthsval)
        data = r[findall(x -> x == key, r[:, 1]), :]
        #data[:, 4] = [hash(data[n, 1], hash(data[n, 2])) for n in eachindex(data[:, 1])] # To sum by time and depth interval
        lines!(
            axv[i], data[:, 2] ./ 30, data[:, 3],
            color=:black,
            linewidth=2.0
        )
    end

    display(fig)
end
