# PLOTS

function plotchannels(p::PhyOutput, channels, tmin, tmax; col = "#4C2C69")
    data = Laska.getchan(p, channels, tmin, tmax, true, true)
    x = collect(0:size(data, 1)-1) ./ 30000
    ysep = maximum(abs.(data)) .* collect((1:length(channels)) .-1)
    fig = Figure(resolution = (600, 600))
    ax = Axis(
        fig[1,1],
        xlabel = "Time [s]",
        ylabel = ""
    )    
    for (n, ch) in enumerate(channels)
    lines!(ax, x, data[:,n] .- ysep[n], color = col, linewidth = 1)
    end
    display(fig)
end