

function plotchannelsinteractive(p::PhyOutput, channels, tmin, tmax; col = standardcol)
    GLMakie.activate!()
    data = Laska.getchan(p, channels, tmin, tmax, true, true)
    x = collect(0:size(data, 1)-1) ./ 30000
    ysep = maximum(abs.(data)) .* collect((1:length(channels)) .-1)
    fig = Figure(resolution = (1920, 1080), fullscreen = true)
    pltgrid = fig[1,1] = GridLayout()
    ctrlgrid = fig[2,1]

    tslider = Slider(ctrlgrid[2,2], range = 0:0.01:parse(Float64, p._meta["fileTimeSecs"]), startvalue = 0)
    txtax = Axis(ctrlgrid[2,1])
    #hidespines!(txtax)
    #hidedecorations!(txtax)
    text!(txtax, "Hej:)", overdraw = true, align = (:center, :bottom))
    

    ax = Axis(
        fig[1,1],
        xlabel = "Time [s]",
        ylabel = ""
    )    
    for (n, ch) in enumerate(channels)
    lines!(ax, x, data[:,n] .- ysep[n], color = col, linewidth = 1)
    end
    rowsize!(fig.layout, 2, Auto(0.05))
    colsize!(fig.layout, 1, Auto(0.2))
    display(fig)
end