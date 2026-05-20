#!/usr/bin/env wish9.0

wm attributes . -topmost 1
wm overrideredirect . 1

wm title . {NERV CLOCK}
tk appname NERVCLOCK

wm geometry . 100x20

set clk 00:00:00.0

font create FNT -family "DSEG7 Modern" -size 12 -weight bold -slant italic

set fg #fb7c00
set bg #222222

label .txt -textvariable clk \
    -justify center -state readonly \
    -fg $fg -bg $bg \
    -font FNT \
    -borderwidth 0 -highlightthickness 0 -relief flat

pack .txt -expand true -fill both


bind . <Configure> {
    set wdg "%W"
    set width "%w"
    set height "%h"
}


proc updclk {} {
    global clk

    set total_ms [clock milliseconds]

    set seconds [expr {$total_ms / 1000}]
    set millis  [expr {$total_ms % 1000}]

    set time_string [clock format $seconds -format "%H:%M:%S"]
    set full_time "${time_string}.[string range [format %03d $millis] 0 0]"

    set clk $full_time
    after 100 updclk
}


proc icesh_me {} {
    set cmd "icesh +c NERVCLOCK borderless bottom right sticky setLayer 12"
    puts $cmd
    if {[catch {exec {*}$cmd} errmsg]} {
        puts stderr "$errmsg"
    }
}


#after 1000 icesh_me


proc move_to_bottom_right {} {
    set win_width [winfo width .]
    set win_height [winfo height .]

    set screen_w [winfo screenwidth .]
    set screen_h [winfo screenheight .]

    set margin_x 0
    set margin_y 0

    set pos_x [expr {$screen_w - $win_width - $margin_x}]
    set pos_y [expr {$screen_h - $win_height - $margin_y}]

    wm geometry . "${win_width}x${win_height}+${pos_x}+${pos_y}"
}



set drag_x 0
set drag_y 0

bind . <Button-1> {
    set drag_x %X
    set drag_y %Y
}

bind . <B1-Motion> {
    set delta_x [expr {%X - $drag_x}]
    set delta_y [expr {%Y - $drag_y}]

    set geo [wm geometry .]
    regexp {(\d+)x(\d+)\+(-?\d+)\+(-?\d+)} $geo match w h x y

    set new_x [expr {$x + $delta_x}]
    set new_y [expr {$y + $delta_y}]
    wm geometry . "${w}x${h}+${new_x}+${new_y}"

    set drag_x %X
    set drag_y %Y
}

bind . <Double-Button-3> {
    exit
}


updclk
after 500 move_to_bottom_right
