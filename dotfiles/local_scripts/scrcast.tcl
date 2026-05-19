#!/usr/bin/env wish9.0

namespace eval shell {
    namespace export check_command ask_location

    proc is_command_available {cmd} {
        global tcl_platform

        if {$tcl_platform(os) eq "Windows NT"} {
            set search_cmd [list where $cmd]
        } else {
            set search_cmd [list which $cmd]
        }

        if {[catch {exec {*}$search_cmd} result] == 0} {
            return 1 ;# OK
        } else {
            return 0
        }
    }

    proc check_command {args} {
        foreach cmd $args {
            if  {![is_command_available $cmd]} {
                tk_messageBox -message "need `$cmd`!" -icon error
                exit -1
            }
        }
    }

    proc ask_location {args} {
        tk_messageBox -message {Move Mouse Pointer and Press Enter...} -icon info
        set s [exec xdotool getmouselocation]
        set s [string map {":" " "} $s]
        # x, y, screen, window
        return [dict create {*}$s]
    }

    namespace ensemble create
}

namespace eval tout {
    namespace export print printnl cls

    proc printnl {txt} {
        print "$txt"
        print "\n"
    }

    proc print {txt} {
        set tout .f_console.tout
        $tout configure -state normal
        $tout insert end "$txt"
        $tout see end
        $tout configure -state disabled
    }

    proc cls {} {
        set tout .f_console.tout
        $tout configure -state normal
        $tout delete 1.0 end
        $tout configure -state disabled
    }

    namespace ensemble create
}

namespace eval geom {
    namespace export calc_by_from_to

    proc calc_by_from_to {from_xy to_xy} {
        lassign [split $from_xy ","] fromx fromy
        lassign [split $to_xy ","] tox toy
        return "[expr $tox - $fromx]x[expr $toy - $fromy]"
    }

    namespace ensemble create
}

namespace eval gui {
    namespace export makewin

    variable seconds 10
    variable framerate 30
    variable output_filename output.mp4
    variable command "..."
    variable from_xy
    variable to_xy

    proc makewin {} {
        wm title . "ffmpeg screencast capture"

        foreach vname {seconds framerate output_filename from_xy to_xy} {
            trace add variable "[namespace current]::${vname}" write "[namespace current]::build_command"
        }

        # --- frame: inputs
        frame .f_form
        set c .f_form
        pack $c -expand false -fill x

        # seconds
        set row 0

        label $c.lbl_seconds -text Seconds:
        entry $c.ent_seconds -textvariable "[namespace current]::seconds"

        grid $c.lbl_seconds -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_seconds -row $row -column 1 -padx 5 -pady 5 -sticky ew

        # framerate = 30
        incr row

        label $c.lbl_framerate -text {Frame rate:}
        entry $c.ent_framerate -textvariable "[namespace current]::framerate"

        grid $c.lbl_framerate -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_framerate -row $row -column 1 -padx 5 -pady 5 -sticky ew

        # output filename
        incr row

        label $c.lbl_output_filename -text {Output Filename:}
        entry $c.ent_output_filename -textvariable "[namespace current]::output_filename"
        button $c.btn_output_filename -text "Select" \
            -command "[namespace current]::select_output_filename"

        grid $c.lbl_output_filename -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_output_filename -row $row -column 1 -padx 5 -pady 5 -sticky ew
        grid $c.btn_output_filename -row $row -column 2 -padx 5 -pady 5 -sticky e

        # from XxY
        incr row

        label $c.lbl_from_xy -text {From X/Y:}
        entry $c.ent_from_xy -textvariable "[namespace current]::from_xy"
        button $c.btn_from_xy -text "Select" \
            -command "[namespace current]::select_from_xy"

        grid $c.lbl_from_xy -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_from_xy -row $row -column 1 -padx 5 -pady 5 -sticky ew
        grid $c.btn_from_xy -row $row -column 2 -padx 5 -pady 5 -sticky e

        # to   XxY
        incr row

        label $c.lbl_to_xy -text {To X/Y:}
        entry $c.ent_to_xy -textvariable "[namespace current]::to_xy"
        button $c.btn_to_xy -text "Select" \
            -command "[namespace current]::select_to_xy"

        grid $c.lbl_to_xy -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_to_xy -row $row -column 1 -padx 5 -pady 5 -sticky ew
        grid $c.btn_to_xy -row $row -column 2 -padx 5 -pady 5 -sticky e

        # command
        incr row

        label $c.lbl_command -text {Command:}
        entry $c.ent_command -textvariable "[namespace current]::command"

        grid $c.lbl_command -row $row -column 0 -padx 5 -pady 5 -sticky w
        grid $c.ent_command -row $row -column 1 -padx 5 -pady 5 -sticky ew

        #
        grid columnconfigure $c 1 -weight 1

        foreach row [lseq 0 $row] {
            grid rowconfigure $c $row -weight 1
        }

        # --- frame: buttons
        frame .f_btns
        set c .f_btns
        pack $c -expand false

        button $c.btn_start -text Start
        button $c.btn_stop  -text Stop

        pack $c.btn_start -side left
        pack $c.btn_stop -side left

        # --- frame: output
        frame .f_console
        set c .f_console
        pack $c -expand true -fill both

        text $c.tout -font TkFixedFont \
            -bg black -fg #00ff00 \
            -yscrollcommand [list $c.yscr set]
        $c.tout configure -wrap char
        $c.tout configure -state disabled

        ttk::scrollbar $c.yscr -orient vertical \
            -command [list $c.tout yview]

        pack $c.yscr -side right -expand 0 -fill y
        pack $c.tout -side left -expand TRUE -fill both

        tout printnl Ready.
    }

    proc select_output_filename {} {
        set file_path [tk_getSaveFile]

        if {$file_path eq ""} {
            puts "파일 선택이 취소되었습니다."
        } else {
            set "[namespace current]::output_filename" $file_path
        }
    }

    proc build_command {n1 n2 op} {
        foreach vname {seconds framerate output_filename from_xy to_xy} {
            variable $vname
        }
        variable command

        set geom [::geom::calc_by_from_to $from_xy $to_xy]

        set cmd "ffmpeg -f x11grab -video_size $geom -framerate $framerate -i $from_xy -t $seconds '$output_filename'"
        set command "$cmd"

        ::tout printnl {--- [New command] ---}
        ::tout printnl "$cmd"
    }

    proc select_xy {} {
        set d [::shell ask_location]
        return "[dict get $d x],[dict get $d y]"
    }

    proc select_from_xy {} {
        variable from_xy
        set from_xy [select_xy]
    }

    proc select_to_xy {} {
        variable to_xy
        set to_xy [select_xy]
    }

    namespace ensemble create
}


# main:

shell check_command ffmpeg xdotool

gui makewin

