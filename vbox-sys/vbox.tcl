#!/usr/bin/tclsh

proc extract_geometry {xwininfo} {
	regexp {geometry (.+)$} $xwininfo geom_tot geom
	return [string trim $geom]
}

proc wh_from_geom {geom} {
    regexp {(\d+)x(\d+).+$} $geom match w h
    return [list $w $h]
}

proc extract_geom_wh {xwininfo} {
    return [wh_from_geom [extract_geometry $xwininfo]]
}


proc get_xwininfo {window_id} {
    return [exec /usr/bin/xwininfo -id $window_id]
}

proc find_vbox_window {} {
    set pid [exec pgrep VirtualBox]
    return [exec xdotool search --pid $pid --onlyvisible]
}

proc find_vbox_window_and_xwininfo {} {
    return [get_xwininfo [find_vbox_window]]
}

proc find_vbox_window_and_rctrl_f {} {
    set window_id [find_vbox_window]
    exec xdotool key --window $window_id "Control_R+F"
}

proc start_vm {vmname} {
    exec /usr/bin/vboxmanage startvm $vmname
}


proc wh_gt {wh_l wh_r} {
    set w_gt [expr [lindex $wh_l 0] > [lindex $wh_r 0]]
    set h_gt [expr [lindex $wh_l 1] > [lindex $wh_r 1]]
    if {$w_gt || $h_gt} {
        return 1
    } else {
        return 0
    }
}

proc is_fullscreen_geom {xwininfo} {
    set root_xwininfo [exec /usr/bin/xwininfo -root]
    set root_wh [extract_geom_wh $root_xwininfo]
    set win_wh [extract_geom_wh $xwininfo]
    return [expr ! [wh_gt $root_wh $win_wh]]
}

proc isnt_vbox_window_fullscreen {} {
    return [expr ! [is_fullscreen_geom [find_vbox_window_and_xwininfo]]]
}

###

start_vm "win7"
catch {find_vbox_window_and_rctrl_f} result

try {
    while 1 {
        if {[catch {exec pgrep VirtualBox} result] == 0} {
            after 1000
	    try {
		    if [isnt_vbox_window_fullscreen] {
		        catch {find_vbox_window_and_rctrl_f} send_fullscreen_ok
		    }
	    }
        } else {
            break
        }
    }
} finally {
        puts "VM TERMINATED."
        exec /usr/bin/poweroff
}


###EOF.
