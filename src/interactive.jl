
using GLMakie
#function plotchannelsinteractive(p::PhyOutput, channels, tmin, tmax; col = standardcol)
    GLMakie.activate!()
    tmax = Observable(1.0)
    tmin = Observable(0.0)
    txt = "+$tmax"

    data = Observable(Laska.getchan(p, channels, tmin[], tmax[], true, true))
    x = Observable(collect(0:size(data[], 1)-1) ./ 30000)
    ysep = maximum(abs.(data[])) .* collect((1:length(channels)) .-1)
    fig = Figure(resolution = (500, 600), fullscreen = true)
    pltgrid = fig[1,1:4] = GridLayout()
    ctrlgrid = fig[2,1:4] = GridLayout()

    inputmin = Textbox(
        ctrlgrid[1,2],
        placeholder = "Tmin",
        reset_on_defocus = true
    )
    inputmin.stored_string = "0"
    inputmax = Textbox(
        ctrlgrid[1,4],
        placeholder = "Length",
        reset_on_defocus = true
    )
    inmin = inputmin.stored_string
    inmax = inputmax.stored_string

    


    Label(ctrlgrid[1,3],
        "-"
    )

    

    ax = Axis(
        pltgrid[1,:],
        xlabel = "Time [s]",
        ylabel = ""
    )    
    for (n, ch) in enumerate(channels)
        lines!(ax, collect(0:size(data[], 1)-1) ./ 30000, data[][:,n] .- ysep[n], linewidth = 1)
    end

    on(inmax) do nt
        data[] = Laska.getchan(p, channels, tmin[], tmin[]+parse(Float64, nt), true, true)
        empty!(ax)
        for (n, ch) in enumerate(channels)
            lines!(ax, collect(0:size(data[], 1)-1) ./ 30000, data[][:,n] .- ysep[n], linewidth = 1)
        end
        @show size(data[])
    end

    colgap!(ctrlgrid, 0)
    rowsize!(fig.layout, 2, Auto(0.05))
    display(fig)
#end