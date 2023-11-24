# IMPORTING but with better wide arrays instead of long. Usually more effective
# memory access(?)

# Initialize a PhyOutput object
struct PhyOutput
    _spiketimes::Matrix{Int64}
    _info::DataFrames.DataFrame
    _meta::Dict{SubString{String},SubString{String}}
    _binpath::String
    _triggers::Union{Vector{Int},Nothing}

    """
        PhyOutput(
            phydir::String = "",
            glxdir::String = "",
            same::Bool = false
        )


    `phydir`: Optional. The directory containing kilosort/phy output.
    `glxdir`: Optional. The directory containing spikeGLX output (.ap.bin/.ap.meta)
    `same`: If true spikeGLX output will be assumed to be in the same directory as Kilosort/Phy output.

    Create a PhyOutput struct containing spiketimes(_spiketimes), info(_info), spikeGLX metadata(_meta) and the path to the associated .ap.bin file(_binpath).
    """

end #struct phyoutput


function importphy(
    phydir::String="",
    glxdir::String="",
    triggerpath::String="",
    same::Bool=false;
    filters=nothing
)
    if Base.length(phydir) == 0
        println("Select phy/kilosort output directory")
        phydir = Gtk.open_dialog_native("Select Kilosort/Phy output Folder", action=GtkFileChooserAction.SELECT_FOLDER)
    end
    if Base.length(glxdir) == 0 && same == false
        println("Select spikeGLX output directory")
        glxdir = Gtk.open_dialog_native("Select spikeGLX output directory", action=GtkFileChooserAction.SELECT_FOLDER)
    end
    if Base.length(glxdir) == 0 && same == true
        glxdir = phydir
    end
    println("Importing good clusters")
    if Sys.iswindows()
        clusters::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_clusters.npy"))
        times::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_times.npy")[:, 1])
        info::DataFrames.DataFrame = CSV.read(phydir * "\\cluster_info.tsv", DataFrame)
    else
        clusters = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_clusters.npy"))
        times = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_times.npy")[:, 1])
        info = CSV.read(phydir * "/cluster_info.tsv", DataFrame)
    end
    spiketimes::Matrix{Int64} = Matrix(undef, 2, length(times))
    spiketimes[1, :] = clusters
    spiketimes[2, :] = times
    spiketimes = spiketimes[:, sortperm(spiketimes[1, :])] # sort by cluster

    isgood(group) = group == "good"
    info = subset(info, :group => ByRow(isgood), skipmissing=true)

    if typeof(filters) != Nothing
        filterinfo(info, filters)
    end

    ininfo(cluster) = cluster in info[!, "cluster_id"]
    spiketimes = spiketimes[:, ininfo.(spiketimes[1, :])]

    glxfiles = readdir(glxdir, join=true)
    binlist = [f for f in glxfiles if f[Base.length(f)-6:Base.length(f)] == ".ap.bin"]
    if length(binlist) > 0
        binfile::String = binlist[1]
    else
        binfile = ""
    end
    metafile::String = [f for f in glxfiles if f[Base.length(f)-7:Base.length(f)] == ".ap.meta"][1]

    # Read metadata
    tmp = open(metafile, "r")
    metaraw = readlines(tmp)
    close(tmp)
    metaraw = split.(metaraw, "=")
    metadict = Dict(i[1] => i[2] for i in metaraw)

    # Read triggerdata
    if triggerpath == ""
        if Gtk.ask_dialog("No triggerpath provided, select a file?")
            triggerpath = Gtk.open_dialog_native("Select triggerfile (.bin/.csv)", action=GtkFileChooserAction.GTK_FILE_CHOOSER_ACTION_OPEN)
            t = importchanint16(triggerpath)
            triggers = gettrig(t)
        else
            triggers = nothing
        end
    else
        t = importchanint16(triggerpath)
        triggers = gettrig(t)
    end

    PhyOutput(spiketimes, info, metadict, binfile, triggers)

end




# Extract triggers from Vector

function gettrig(t::Vector)
    r::Vector = findall(!iszero, t)
    p::Matrix{Int64} = hcat(getindex.(r, 1), getindex.(r - circshift(r, 1), 1))
    s::Vector{Int64} = p[p[:, 2].!=1, 1]
    return s
end

# TODO Add methods for channel spec types?
function getchan(
    p::PhyOutput,
    ch::Union{Int,Vector{Int},UnitRange{Int64}},
    tmin::Union{Float64,Int},
    tmax::Union{Float64,Int,String},
    converttoV::Bool=true,
    threading::Bool=false
)

    filemax::Int64 = Int64(parse(Int64, p._meta["fileSizeBytes"]) / parse(Int64, p._meta["nSavedChans"]) / 2)
    samplfrq::Float64 = parse(Float64, p._meta["imSampRate"])
    # Convert times (IN SECONDS) to sample frequencies
    # Add 1 since indexing is 1-based(?)

    #Check if tmin < 0
    if tmin < 0
        ArgumentError("tmin must be above 0")
    end

    # Check if max time should be used
    if typeof(tmax) == String
        if tmax != "max"
            ArgumentError("tmax must be a number or the string 'max'")
        end
        tmax = filemax
    else
        # Convert tmax to sample frequency
        tmax::Int64 = Int(round((tmax * samplfrq))) + 1::Int64
    end
    # Check if tmin >= tmax
    if tmin >= tmax
        ArgumentError("tmin must be <tmax")
    end

    # Convert tmin to sample frequency
    tmin::Int64 = Int(round((tmin * samplfrq))) + 1::Int64

    if tmax > filemax
        ArgumentError("tmax larger than length of recording")
    end

    # Memory map data and load the selected chunks
    karta::Matrix{Int16} = spikemmap(p)
    len::UnitRange{Int64} = tmin:tmax
    #it::Vector{Tuple{Int64, Int64}} = collect(enumerate(len))

    if threading
        r::Union{Matrix{Int16},Vector{Int16}} = Matrix{Int16}(undef, length(len), length(ch))
        t::Vector{UnitRange{Int64}} = collect(Iterators.partition(len, 10000))
        n::Vector{UnitRange{Int64}} = collect(Iterators.partition(1:length(len), 10000))
        it = tuple.(n, t)
        #it = collect(enumerate(len))


end

        if length(ch) > 1
            Laska.importchx!(ch, r, karta, it)
        elseif length(ch) == 1
            Laska.importch1!(ch, r, karta, it)
        end
    else
        r = karta[ch, len]
    end

    if converttoV
        conv::Union{Matrix{Float64},Vector{Float64}} = tovolts(p._meta, r)
        return conv
    else
        return r
    end

end # Getchan



function importchx!(channels::Union{Int,Vector{Int},UnitRange{Int64}}, a::Matrix{Int16}, mm::Matrix{Int16}, i::Vector{Tuple{UnitRange{Int64},UnitRange{Int64}}})
    for (ntim, t) in i
        a[ntim, :] = transpose(mm[channels, t])
    end
    return a
end

function importch1!(channels::Union{Int,Vector{Int},UnitRange{Int64}}, a::Vector{Int16}, mm::Matrix{Int16}, i::Vector{Tuple{UnitRange{Int64},UnitRange{Int64}}})
    for (ntim, t) in i
        a[ntim, 1] = mm[channels, t]
    end
    return a
end

function spikemmap(p::PhyOutput)
    n::Int = parse(Int, p._meta["nSavedChans"])
    s::Int = Int(parse(Int, p._meta["fileSizeBytes"]) / (2 * n))
    tmp::IOStream = open(p._binpath, "r")
    m::Array{Int16,2} = mp.mmap(tmp, Array{Int16,2}, (n, s), 0)
    close(tmp)
    return m
end # spikemmap

function tovolts(meta::Dict{SubString{String},SubString{String}}, i::Union{Vector{Int16},Array{Int16}})
    Imax::Float64 = parse(Float64, meta["imMaxInt"])
    Vmax::Float64 = parse(Float64, meta["imAiRangeMax"])
    if meta["imDatPrb_type"] == "0"
        tbl = meta["~imroTbl"]
        tbl = split(tbl, ")(")
        tbl = split(tbl[2], " ")
        gain = parse(Int, tbl[4])
    else
        gain::Float64 = 80
    end
    cfactor::Float64 = Vmax / Imax / gain
    return i .* cfactor
end # tovolts


function importchanint16(path::String="")
    if path == ""
        path = Gtk.open_dialog_native("Select trigger file", action=GtkFileChooserAction.GTK_FILE_CHOOSER_ACTION_OPEN)
    end
    if path[end-3:end] == ".bin"
        tmp::IOStream = open(path, "r")
        res = Array(reinterpret(Int16, read(tmp)))
        close(tmp)
        return res
    elseif path[end-3:end] == ".csv"
        res2::Vector = Vector(Matrix(CSV.read(path, DataFrame, header=false))[:, 1])
        return res2
    else
        ArgumentError("Only '.bin' or '.csv' files allowed.")
    end
end #importchan

