#!/usr/bin/env wish9.0

namespace eval shell {
    namespace export check_command check_xorg_display \
        ask_mouse_location \
        run_shell_command kill_shell_command kill_process \
        ShCommandReader
    namespace ensemble create

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

    proc check_xorg_display {} {
        if {[catch {set display $::env(DISPLAY)} errmsg]} {
            tk_messageBox -message "need Xorg DISPLAY!" -icon error
            exit -1
        }
        return $display
    }

    proc ask_mouse_location {args} {
        tk_messageBox -message {Move Mouse Pointer and Press Enter...} -icon info
        set s [exec xdotool getmouselocation]
        set s [string map {":" " "} $s]
        # x, y, screen, window
        return [dict create {*}$s]
    }

    proc kill_process {name_or_pid {is_pid 0}} {
        global tcl_platform
        set os $tcl_platform(os)

        switch -glob $os {
            "Windows*" {
                if {$is_pid} {
                    set cmd [list exec taskkill /F /PID $name_or_pid]
                } else {
                    set cmd [list exec taskkill /F /IM $name_or_pid /T]
                }
            }
            "Darwin" -
            "Linux" {
                if {$is_pid} {
                    set cmd [list exec kill -9 $name_or_pid]
                } else {
                    set cmd [list exec pkill -9 $name_or_pid]
                }
                #catch {exec pkill -P {*}$pids}
                #catch {exec kill {*}$pids}
            }
            default {
                error "Unsupported OS: $os"
            }
        }

        # 실행 및 에러 처리
        if {[catch { {*}$cmd } msg]} {
            error "ERROR: $msg"
        }
    }

    oo::class create ShCommandReader {
        variable _cmd
        variable _pipe
        variable _println_cb
        variable _print_nonewline_cb
        variable _running_cb
        variable _finished_cb
        variable _expecting_result_file

        constructor {args} {
            set defaults {
                println_cb         {{txt} {}}
                print_nonewline_cb {{txt} {}}
                running_cb         {{} {}}
                finished_cb        {{} {}}
                expecting_result_file ""
            }

            set args_ [dict merge $defaults $args]
            # puts $args_

            my variable _cmd
            my variable _pipe
            my variable _println_cb
            my variable _print_nonewline_cb
            my variable _running_cb
            my variable _finished_cb
            my variable _expecting_result_file

            dict with args_ {
                set _cmd $cmd
                set _pipe ""
                set _println_cb $println_cb
                set _print_nonewline_cb $print_nonewline_cb
                set _running_cb $running_cb
                set _finished_cb $finished_cb
                set _expecting_result_file $expecting_result_file
            }
        }

        method println {args} {
            variable _println_cb
            apply $_println_cb {*}$args
        }

        method print_nonewline {args} {
            variable _print_nonewline_cb
            apply $_print_nonewline_cb {*}$args
        }

        method set_as_running {} {
            variable _running_cb
            apply $_running_cb
        }

        method set_as_finished {} {
            variable _finished_cb
            apply $_finished_cb
        }

        method start {} {
            variable _pipe
            variable _cmd

            my set_as_running

            set _pipe [open "|$_cmd 2>@1" r]
            fconfigure $_pipe \
                -blocking 0 -buffering full \
                -translation binary
            fileevent $_pipe readable [callback _onread $_pipe]
        }

        method _onread {ch} {
            if {[eof $ch]} {
                my set_as_finished

                my println "\n--- EOF: $ch ---"
                if {[catch {close $ch} errmsg]} {
                    my println "\nEXITED: $errmsg"
                }

                my variable _expecting_result_file
                if {[file exists $_expecting_result_file]} {
                    tout println "RESULT-FILE: $_expecting_result_file // size= [file size $_expecting_result_file]"
                } else {
                    tout println "NO-RESULT-FILE: $_expecting_result_file"
                }

                my destroy
            } else {
                set data [read $ch 100]
                my print_nonewline $data
            }
        }

        method kill {} {
            my variable _pipe

            if {[string length $_pipe] == 0} {return}

            try {
                set pids [pid $_pipe]
                my println "--- KILL: $pids ---"
                catch [list [namespace current]::kill_process $pids 1]
            } on error {err erropts} {
                my println "--- WARN: $err ---"
            }

            set _pipe ""
        }
    }
}

namespace eval tout {
    namespace export print println cls
    namespace ensemble create

    proc println {txt} {
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
}

namespace eval geom {
    namespace export calc_by_from_to calc_width_height x_and_y
    namespace ensemble create

    proc x_and_y {xy} {
        split $xy ","
    }

    proc calc_width_height {from_xy to_xy} {
        lassign [x_and_y $from_xy] fromx fromy
        lassign [x_and_y $to_xy] tox toy
        return [list [expr $tox - $fromx] [expr $toy - $fromy]]
    }

    proc calc_by_from_to {from_xy to_xy} {
        lassign [calc_width_height $from_xy $to_xy] w h
        return "${w}x${h}"
    }
}

namespace eval gui {
    namespace export makewin set_xorg_display check_before_flight \
        state_as_ready state_as_running kill_recording \
        show_overlay_auto
    namespace ensemble create

    variable seconds 10
    variable framerate 30
    variable output_filename ~/w/output.mp4
    variable command "..."
    variable from_xy "0,0"
    variable to_xy   "300,200"
    variable xorg_display
    variable xorg_screen_from_xy "0"
    variable xorg_screen_to_xy   "0"

    variable shcmd_rdr_ffmpeg ""

    proc set_xorg_display {display} {
        variable xorg_display
        set xorg_display $display
    }

    proc makewin {} {
        wm title . "ffmpeg screencast capture"

        wm protocol . WM_DELETE_WINDOW {
            catch "[namespace current]::kill_recording"
            exit
        }

        foreach vname {seconds framerate output_filename from_xy to_xy} {
            trace add variable "[namespace current]::${vname}" write "[namespace current]::vtrace"
        }

        #
        set pads {-padx 3 -pady 3}

        # --- frame: inputs
        frame .f_form
        set c .f_form
        pack $c -expand false -fill x

        # seconds
        set row 0

        label $c.lbl_seconds -text Seconds:
        entry $c.ent_seconds -textvariable "[namespace current]::seconds"

        grid $c.lbl_seconds -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_seconds -row $row -column 1 {*}$pads -sticky ew

        # framerate = 30
        incr row

        label $c.lbl_framerate -text {Frame rate:}
        entry $c.ent_framerate -textvariable "[namespace current]::framerate"

        grid $c.lbl_framerate -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_framerate -row $row -column 1 {*}$pads -sticky ew

        # output filename
        incr row

        label $c.lbl_output_filename -text {Output Filename:}
        entry $c.ent_output_filename -textvariable "[namespace current]::output_filename"
        button $c.btn_output_filename -text "Select" \
            -command "[namespace current]::select_output_filename"

        grid $c.lbl_output_filename -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_output_filename -row $row -column 1 {*}$pads -sticky ew
        grid $c.btn_output_filename -row $row -column 2 {*}$pads -sticky e

        # from XxY
        incr row

        label $c.lbl_from_xy -text {From X/Y:}
        entry $c.ent_from_xy -textvariable "[namespace current]::from_xy"
        button $c.btn_from_xy -text "Select" \
            -command "[namespace current]::select_from_xy"

        grid $c.lbl_from_xy -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_from_xy -row $row -column 1 {*}$pads -sticky ew
        grid $c.btn_from_xy -row $row -column 2 {*}$pads -sticky e

        # to   XxY
        incr row

        label $c.lbl_to_xy -text {To X/Y:}
        entry $c.ent_to_xy -textvariable "[namespace current]::to_xy"
        button $c.btn_to_xy -text "Select" \
            -command "[namespace current]::select_to_xy"

        grid $c.lbl_to_xy -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_to_xy -row $row -column 1 {*}$pads -sticky ew
        grid $c.btn_to_xy -row $row -column 2 {*}$pads -sticky e

        # command
        incr row

        label $c.lbl_command -text {Command:}
        entry $c.ent_command -textvariable "[namespace current]::command"

        grid $c.lbl_command -row $row -column 0 {*}$pads -sticky w
        grid $c.ent_command -row $row -column 1 {*}$pads -sticky ew

        #
        grid columnconfigure $c 1 -weight 1

        foreach row [lseq 0 $row] {
            grid rowconfigure $c $row -weight 1
        }

        # --- frame: buttons
        frame .f_btns
        set c .f_btns
        pack $c -expand false {*}$pads

        button $c.btn_start -text Start \
            -command "[namespace current]::start_recording"
        button $c.btn_stop  -text Stop \
            -command "[namespace current]::kill_recording"

        button $c.btn_show_overlay  -text "Show Region" \
            -command "[namespace current]::show_overlay_auto"

        pack $c.btn_start -side left {*}$pads
        pack $c.btn_stop -side left {*}$pads
        pack $c.btn_show_overlay -side left {*}$pads

        # --- frame: output
        frame .f_console
        set c .f_console
        pack $c -expand true -fill both {*}$pads

        text $c.tout -font TkFixedFont \
            -bg black -fg #00ff00 \
            -yscrollcommand [list $c.yscr set]
        $c.tout configure -wrap char
        $c.tout configure -state disabled

        ttk::scrollbar $c.yscr -orient vertical \
            -command [list $c.tout yview]

        pack $c.yscr -side right -expand false -fill y
        pack $c.tout -side left -expand true -fill both

        build_command
        state_as_ready

        tout println Ready.
    }

    proc start_recording {} {
        if {![gui check_before_flight]} {
            return
        }

        variable shcmd_rdr_ffmpeg
        if {![string equal $shcmd_rdr_ffmpeg ""]} {
            return
        }

        variable command
        variable output_filename
        set shcmd_rdr_ffmpeg \
            [::shell::ShCommandReader new \
                 cmd "$command" \
                 expecting_result_file [file tildeexpand $output_filename] \
                 println_cb {{txt} { ::tout println "$txt" }} \
                 print_nonewline_cb {{txt} { ::tout print "$txt" }} \
                 running_cb {{} {
                     ::gui state_as_running
                 }} \
                 finished_cb {{} {
                     ::gui state_as_ready
                     ::gui kill_recording
                 }}]
        $shcmd_rdr_ffmpeg start
    }

    proc kill_recording {} {
        variable shcmd_rdr_ffmpeg
        if {![string equal $shcmd_rdr_ffmpeg ""]} {
            $shcmd_rdr_ffmpeg kill
            set shcmd_rdr_ffmpeg ""
        }
    }

    proc state_as_ready {} {
        .f_btns.btn_start configure -state normal
        .f_btns.btn_stop configure -state disabled
    }

    proc state_as_running {} {
        .f_btns.btn_start configure -state disabled
        .f_btns.btn_stop configure -state normal
    }

    proc select_output_filename {} {
        set file_path [tk_getSaveFile]

        if {$file_path eq ""} {
            # puts "Canceled."
        } else {
            set "[namespace current]::output_filename" $file_path
        }
    }

    proc vtrace {n1 n2 op} {
        build_command
    }

    proc build_command {} {
        foreach vname {seconds framerate output_filename from_xy to_xy xorg_display xorg_screen_from_xy} {
            variable $vname
        }
        variable command

        set geom "???"
        catch {
            set geom [::geom::calc_by_from_to $from_xy $to_xy]
        }

        tout println $xorg_display
        tout println $xorg_screen_from_xy
        tout println $from_xy
        set from_xy2 "${xorg_display}.${xorg_screen_from_xy}+${from_xy}"

        set output_filename2 $output_filename
        catch {
            set output_filename2 [file tildeexpand $output_filename2]
        }

        # -an : no-audio
        # -n  : no-overwriting
        set cmd "ffmpeg -f x11grab -video_size $geom -framerate $framerate -i $from_xy2 -t $seconds -an -n $output_filename2"
        set command "$cmd"

        ::tout println {--- [New command] ---}
        ::tout println "$cmd"
    }

    proc check_before_flight {} {
        variable xorg_screen_from_xy
        variable xorg_screen_to_xy
        if {![string equal $xorg_screen_from_xy $xorg_screen_to_xy]} {
            tk_messageBox -message "Does not support different Xorg screens (from: $xorg_screen_to_xy, to: $xorg_screen_to_xy)" -icon warning
            return false
        }
        return true
    }

    foreach namepart {from_xy to_xy} {
        set code [subst -nocommands {proc select_${namepart} {} {
            set d [::shell ask_mouse_location]

            variable xorg_screen_$namepart
            set xorg_screen_$namepart [dict get \$d screen]

            set g "[dict get \$d x],[dict get \$d y]"
            variable $namepart
            set $namepart "\$g"
        }}]
        eval $code
    }

    proc show_overlay_auto {} {
        variable from_xy
        variable to_xy
        lassign [::geom calc_width_height $from_xy $to_xy] w h
        lassign [::geom x_and_y $from_xy] x y
        show_overlay $x $y $w $h
    }

    proc show_overlay {x y win_w win_h} {
        set mw .mw

        if {[winfo exists $mw]} {
            return
        }

        toplevel $mw

        wm overrideredirect $mw 1
        wm attributes $mw -topmost 1

        wm geometry $mw "${win_w}x${win_h}+${x}+${y}"

        global tcl_platform
        set os $tcl_platform(os)

        if {$os eq "Windows NT"} {
            $mw configure -bg magenta
            wm attributes $mw -transparentcolor magenta
        } else {
            $mw configure -bg "#111111"
            wm attributes $mw -alpha 0.6
        }

        if {$os eq "Windows NT"} {
            set canvas_bg magenta
        } else {
            set canvas_bg "#111111"
        }

        set c [canvas $mw.canvas -bg $canvas_bg -highlightthickness 0]
        pack $c -fill both -expand 1

        set cx [expr {$win_w / 2}]
        set cy [expr {$win_h / 2}]
        set len 30

        $c create line [expr {$cx - $len}] $cy [expr {$cx + $len}] $cy -fill "#ffffff" -width 2
        $c create line $cx [expr {$cy - $len}] $cx [expr {$cy + $len}] -fill "#ffffff" -width 2

        $c create text $cx [expr {$win_h - 40}] -text "종료하려면 클릭 / Click to dismiss" -fill "#aaaaaa" -font {Helvetica 12 bold}

        bind $mw <Button-1> [list destroy $mw]
    }
}


# main:

shell check_command ffmpeg xdotool
gui set_xorg_display [shell check_xorg_display]

gui makewin

# TODO mpv it

