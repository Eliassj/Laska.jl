##############################################
#
# Import output from phy as a PhyOutput struct
#
##############################################

# NOTE: Importfunktioner typ klara.
# TODO: Support för flera filterfunktioner
"""

    function importphy(phydir::String, glxdir::String, triggerpath::String; triggers=true)

Import output from phy. Spiketimes are in reverse chronological order and not guaranteed to be sorted.

"""
function importphy(phydir::String, glxdir::String, triggerpath::String; triggers=true)
    if Sys.iswindows()
        clusters::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_clusters.npy"))
        times::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_times.npy")[:, 1])
        info::DataFrames.DataFrame = CSV.read(phydir * "\\cluster_info.tsv", DataFrame)
    else
        clusters = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_clusters.npy"))
        times = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_times.npy")[:, 1])
        info = CSV.read(phydir * "/cluster_info.tsv", DataFrame)

    end

    idvec::Vector{Int64} = info[!, "cluster_id"]

    clustervec::Vector{Cluster{Int64}} = Vector(undef, 0)

    resdict::Dict{Int64,Vector{Int64}} = Dict(c => Vector{Int64}(undef, 0) for c in idvec)

    for _ in eachindex(clusters)
        cluster::Int64 = pop!(clusters)
        time::Int64 = pop!(times)
        push!(resdict[cluster], time)
    end
    isgood(group) = group == "good"
    info = subset(info, :group => ByRow(isgood), skipmissing=true)
    idvec = info[!, "cluster_id"]

    for id in idvec
        inf::Dict{String,String} = Dict()
        for col in names(info)
            inf[col] = string(filter(:cluster_id => x -> x == id, info)[!, col][1])
        end
        push!(clustervec, Cluster(id, inf, resdict[id]))
    end

    if triggers
        t = importchanint16(triggerpath)
        triggers = gettrig(t)
    else
        triggers = Vector{Int64}(undef, 0)
    end

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
    metadict = Dict{SubString{String},SubString{String}}(i[1] => i[2] for i in metaraw)

    return PhyOutput(idvec, clustervec, triggers, metadict)
end


# Version with filters
function importphy(phydir::String, glxdir::String, triggerpath::String, filters::Tuple{Symbol,Function}; triggers=true)
    if Sys.iswindows()
        clusters::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_clusters.npy"))
        times::Vector{Int64} = convert(Vector{Int64}, NPZ.npzread(phydir * "\\spike_times.npy")[:, 1])
        info::DataFrames.DataFrame = CSV.read(phydir * "\\cluster_info.tsv", DataFrame)
    else
        clusters = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_clusters.npy"))
        times = convert(Vector{Int64}, NPZ.npzread(phydir * "/spike_times.npy")[:, 1])
        info = CSV.read(phydir * "/cluster_info.tsv", DataFrame)
    end



    idvec::Vector{Int64} = info[!, "cluster_id"]


    clustervec::Vector{Cluster{Int64}} = Vector(undef, 0)

    resdict::Dict{Int64,Vector{Int64}} = Dict(c => Vector{Int64}(undef, 0) for c in idvec)

    for _ in eachindex(clusters)
        cluster::Int64 = pop!(clusters)
        time::Int64 = pop!(times)
        push!(resdict[cluster], time)

    end

    isgood(group) = group == "good"
    info = subset(info, :group => ByRow(isgood), skipmissing=true)
    filter!(filters[1] => filters[2], info)
    idvec = info[!, "cluster_id"]

    for id in idvec
        inf::Dict{String,String} = Dict()
        for col in names(info)
            inf[col] = string(filter(:cluster_id => x -> x == id, info)[!, col][1])
        end
        push!(clustervec, Cluster(id, inf, resdict[id]))
    end

    if triggers
        t = importchanint16(triggerpath)
        triggers = gettrig(t)
    else
        triggers = Vector{Int64}(undef, 0)
    end

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
    metadict = Dict{SubString{String},SubString{String}}(i[1] => i[2] for i in metaraw)

    return PhyOutput(idvec, clustervec, triggers, metadict)
end


