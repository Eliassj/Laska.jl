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

function plotraster(t::Laska.relativeSpikes, cluster::Int64, col::String = standardcol, scattersize = 7)
    data = t._spiketimes[t._spiketimes[:,1] .== cluster,:]
    xdat = data[:,2] ./ (parse(Float64, t._meta["imSampRate"]) / 1000)
    ydat = data[:,3]
    xt = collect(values(t._stimulations))
    pushfirst!(xt, -t._specs["back"])
    push!(xt, t._specs["forward"])
    d = sort(t._stimulations, byvalue = true)
    xl = ["$v($k)" for (k, v) in collect(d)]
    push!(xl, string(t._specs["forward"]))
    pushfirst!(xl, string(-t._specs["back"]))
    xlabs = (xt, xl)
    yt = [0, t._specs["ntrig"]]


    fig = Figure(resolution = (1000, 1000))
    gsc = fig[2,1] = GridLayout()
    ghi = fig[1,1] = GridLayout()
    # Axis for scatterplot
    axsc = Axis(
        gsc[1,1],
        xlabel = "Time [ms]",
        ylabel = "Session",
        xgridvisible = false,
        ygridvisible = false,
        xticks = xlabs,
        yticks = yt,
        yticksize = 0
    )
    hidespines!(axsc, :t, :r, :l)
    axsc.yticklabelspace = 1.0
    # Axis for histogram
    axhi = Axis(
        ghi[1,1]
    )
    hidedecorations!(axhi)
    hidespines!(axhi)
    for s in values(t._stimulations)
        vlines!(
            axsc,
            s,
            ymin = 0.0,
            ymax = 1.0,
            color = "#000000"
        )
    end
    scatter!(
        axsc,
        xdat,
        ydat,
        markersize = scattersize,
        color = col
    )
    hist!(
        axhi,
        xdat,
        bins = t._specs["back"] + t._specs["forward"],
        color = col
    )
    rowsize!(fig.layout, 1, Auto(0.25))
    rowgap!(fig.layout, 1, 0)
    linkxaxes!(axhi, axsc)
    display(fig)
end

function plotisi(p::Laska.PhyOutput, cluster::Int)
    dict = spikeisi(p)
    x = p._spiketimes[p._spiketimes[:,1] .== cluster, 2][1:end-1]
    y = dict[cluster]
    fig = Figure()
    ax = Axis(fig[1,1])
    lines!(x, y)
    display(fig)
end

function plotcv2(p::PhyOutput, cluster::Int64)
    data = cv2(p)
    clustr = Int(cluster)
    fig = Figure()
    ax = Axis(
        fig[1,1],
        xlabel = "CV2"
    )
    hist!(
        ax,
        data[data[:,1] .== clustr, 2],
        bins = 250
    )
    display(fig)
end

function plotsumstat(p::PhyOutput, x::String, y::String)
    data = p._info
    fig = Figure()
    ax = Axis(
        fig[1,1],
        xlabel = x,
        ylabel = y
    )
    scatter!(
        ax,
        data[!,x],
        data[!,y] 
    )
    display(fig)
end

function plotsumstat(p::PhyOutput, x::String, y::String, z::String)
    GLMakie.activate!()
    data = p._info
    fig = Figure()
    ax = Axis3(
        fig[1,1],
        xlabel = x,
        ylabel = y,
        zlabel = z
    )
    scatter!(
        ax,
        data[!,x],
        data[!,y] ,
        data[!,z]
    )
    display(fig)
end