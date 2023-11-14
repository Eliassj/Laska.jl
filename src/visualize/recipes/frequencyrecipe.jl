
MakieCore.@recipe(FrequencyByDepthPlot, experiment, depths, period) do scene
    Attributes(
        color=standardcol
    )
end


function MakieCore.plot!(plt::FrequencyByDepthPlot)
    p = plt.experiment

    depths = plt.depths

    period = plt.period

    lins = MakieCore.Observable(Vector{Vector{Float64}}(undef, 0))

    function update_plot(p, depths, period)
        empty!(lins[])
        tims = frequency(p[], depths[], period[])
        for i in eachindex(tims)
            push!(lins[], tims[i])
        end
        maxresp = maximum(maximum(lins[])) + abs(minimum(minimum(lins[])))
        for i in length(lins[]):-1:1
            lins[][i] .+= (((i - 1) * maxresp) - 1)
        end


    end
    Makie.Observables.onany(update_plot, p, depths, period)
    update_plot(p, depths, period)

    for i in eachindex(lins[])
        lines!(
            plt,
            lins[][i]
        )
    end
end
