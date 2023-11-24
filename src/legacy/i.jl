# IMPORTING

# Initialize a PhyOutput object
mutable struct PhyOutput
    _spiketimes::Matrix{Int64}
    _info::DataFrames.DataFrame
    const _meta::Dict{SubString{String},SubString{String}}
    const _binpath::String
    const _triggers::Union{Vector{Int},Nothing}
end

"""      PhyOutput(
        phydir::String = "",
        glxdir::String = "",
          same::Bool = false#       
    `phydir`: Optional. The directy containing kilosort/phy output.
    `glxdir`: Optional. The directory containing spikeGLX output (.ap.bin/.ap.meta)
    `same`: If true spikeGLX output will be assumed to be in the same directory as Kilosort/Phy output.

    Create a PhyOutput struct containing spiketimes(_spiketimes), info(_info), spikeGLX metadata(_meta) and the path to the associated .ap.bin file(_binpath).
    """
function importphy(phydir::String="", glxdir::String="", triggerpath::String="", same::Bool=false; filters=nothing)
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
    spiketimes::Matrix{Int64} = [clusters times]
    spiketimes = spiketimes[sortperm(spiketimes[:, 1]), :] # sort by cluster

    isgood(group) = group == "good"
    info = subset(info, :group => ByRow(isgood), skipmissing=true)

    if typeof(filter) != Nothing
        filterinfo(info, filters)
    end

    ininfo(cluster) = cluster in info[!, "cluster_id"]
    spiketimes = spiketimes[findall(ininfo, (spiketimes[:, 1])), :]

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

