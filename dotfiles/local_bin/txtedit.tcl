#!/usr/bin/env tclsh9.0

# [2026-07-07 Tue 00:00] first prototype
#
# ... I know, it's a mess, but 샤 works!


proc chk_shell_command {cmd} {
    if {[auto_execok $cmd] ne ""} {
        return true
    } else {
        package require Tk
        tk_messageBox -type ok -icon error -title Command -detail "Error: \"$cmd\" is not found on this system."
        exit -1
    }
}

proc paste_clipboard {txt} {
    set pipe [open "|xclip -selection clipboard" "r+"]
    puts -nonewline $pipe $txt
    flush $pipe
    close $pipe
}

proc send_text {} {
    global WID
    set txt [.fedit.t get 1.0 end]
    # puts $txt

    paste_clipboard $txt
    exec xdotool key --clearmodifiers --window $WID shift+Insert

    exit 0
}

chk_shell_command xdotool
chk_shell_command xclip

set WID [exec xdotool getactivewindow]


package require Tk

wm geometry . 300x200


frame .fbtns
pack .fbtns -side bottom -expand FALSE -fill none

set c .fbtns

button $c.btn_send -text "Send (Ctrl-d)" -command send_text
bind . <Control-d> send_text

pack $c.btn_send


frame .fedit
pack .fedit -side top -expand TRUE -fill both

set c .fedit

text $c.t -font TkFixedFont \
    -yscrollcommand [list $c.yscr set]
$c.t configure -wrap char

ttk::scrollbar $c.yscr -orient vertical \
    -command {.feditt yview}

pack $c.yscr -side right -expand 0 -fill y
pack $c.t -side left -expand TRUE -fill both


focus .fedit.t
