# PLOTS

function plotchannels(p::PhyOutput, channels, tmin, tmax; col = standardcol)
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

function plotraster(t::Laska.relativeSpikes, cluster::Int64, col = standardcol)
    data = t._spiketimes[findall(x -> x == cluster, t._spiketimes[:,1]),:]
    fig = Figure()
    ax = Axis(
        fig[1,1],
        xlabel = "Time [ms]",
        ylabel = "Session"
    )
    scatter!(
        ax,
        data[:,2] ./ (parse(Float64, t._meta["imSampRate"]) / 1000),
        data[:,3],
        markersize = 4,
        color = col
    )
    display(fig)
    
end