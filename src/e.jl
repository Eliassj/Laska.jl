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
    open(dest, "w") do file
        write(file, channel)            
        close(file)
    end   
    println("written to: ", dest)
end # writechanbin