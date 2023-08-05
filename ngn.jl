using Gtk

function build_menu()
    filemenu = Gtk.Menu()

    quit_item = Gtk.MenuItem("Quit")

    append!(filemenu, quit_item)

    file = Gtk.MenuItem("File")

    menubar = Gtk.MenuBar()
    push!(menubar, file)

    return menubar
end

function main()

    win = Gtk.Window("Julia Gtk Menu Example")
    win.border_width = 10
    win.set_default_size(400, 300)

    # Build the menu bar
    menubar = build_menu()

    # Create a vertical box container to hold the menu bar and other widgets
    vbox = Gtk.VBox()

    # Pack the menu bar into the vertical box
    pack_start(vbox, menubar, false, false, 0)

    # Add other widgets to the vertical box as needed
    # For example, you can add buttons, labels, etc.

    # Add the vertical box to the window
    add(win, vbox)

    showall(win)
    Gtk.main()
end

main()
