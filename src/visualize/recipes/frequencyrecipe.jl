
@recipe(FrequencyByDepthPlot, depths) do scene
    Attributes(
        color=standardcol
    )
end

function GLMakie.plot!(plt::FrequencyByDepthPlot{<:Tuple{<:PhyOutput}})

end
