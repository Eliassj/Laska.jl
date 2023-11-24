# EXPORTING

function writechanbin(
    channel::Union{Matrix{Float64}, Matrix{Int16}, Vector{Int16}, Vector{Float64}},
    dest::String="")

    if dest == ""
        dest = Gtk.open_dialog_native("Select save location", action=GtkFileChooserAction.SAVE)
    end
    if dest[end-3:end] != ".bin"
        dest = dest*".bin"
    end
    file = open(dest, "w")
    bytes = write(file, channel)            
    close(file)
    println("written ", bytes, " bytes to: ", dest)
end # writechanbin