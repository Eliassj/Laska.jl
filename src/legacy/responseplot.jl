function responseplot(t::relativeSpikes, period::Int64, depthdiv::Int64=4)
    r = relresponse(t, period, depthbaseline(t), depthdiv)
    depthsval::Vector{Float64} = [minimum(r[:, 1]) * i for i in 1:depthdiv]
    fig = Figure()
    axv = Vector{Axis}(undef, depthdiv)
    stimlabs = _tickify(t._stimulations, true)
    xts = append!(append!([-t._specs["back"]], stimlabs[3]), [t._specs["forward"]])
    xlabs::Vector{String} = append!(append!([string(-t._specs["back"])], stimlabs[1]), [string(t._specs["forward"])])
    # Create axes
    for n in 1:depthdiv
        if n < depthdiv
            # If not the bottommost axis...
            axv[n] = Axis(
                fig[n, 1],
                xticks=xts,
                xticksvisible=false,
                xticklabelsvisible=false,
                xgridwidth=2.5,
                yticklabelsvisible=false,
                yticksvisible=false,
                yticks=[1.0],
                ylabel=string(Int(depthsval[1]) * (n - 1)) * " - " * string(Int(depthsval[1]) * n) * " µm",
                ylabelrotation=π * 2
            )
            hidespines!(axv[n])
        else
            # If the bottommost axis...
            axv[n] = Axis(
                fig[n, 1],
                xticks=(xts, xlabs),
                xgridwidth=2.0,
                xlabel="Time (ms)",
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
        lines!(
            axv[i], data[:, 2] ./ 30, data[:, 3],
            color=:black,
            linewidth=2.0
        )
    end

    display(fig)
    return fig, axv
end

function _tickify(stimdict::Dict{String,T}, return_all::Bool=false) where {T}
    vals::Vector{T} = collect(
        values(stimdict)
    )
    names::Vector{String} = collect(
        Base.keys(stimdict)
    )
    srt = sortperm(vals)
    vals = vals[srt]
    names = names[srt]
    out::Vector{String} = Vector(undef, length(vals))
    n = 1
    for (key, val) in zip(names, vals)
        out[n] = string(val) * " (" * key * ")"
        n += 1
    end
    if return_all
        return out, names, vals
    else
        return out
    end
end
