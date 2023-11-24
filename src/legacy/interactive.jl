#############################
#
# Functions for windows etc
#
#############################

function clickedyes(w)
    global ans = true
end

function clickedno(w)
    global ans = false
end

function yesnodialog(question::String)
    yesb = GtkButton("Yes")
    nob = GtkButton("No")
    win = GtkWindow(question, 100, 150)
    vbox = GtkBox(:v)
    push!(win, vbox)
    push!(vbox, yesb)
    push!(vbox, nob)
    showall(win)
    ans::Int = 2

    function button_clicked_yes(widget)
        destroy(win)
        ans = 1
    end

    function button_clicked_no(widget)
        destroy(win)
        ans = 0
    end

    while ans == 2
        id = signal_connect(button_clicked_yes, yesb, "clicked")
        id2 = signal_connect(button_clicked_no, nob, "clicked")
    end
    return Bool(ans)
end
