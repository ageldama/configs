#!/usr/bin/env wish9.0

namespace eval shell {
    namespace export check_command ask_mouse_location run_shell_command kill_shell_command kill_process
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

    proc ask_mouse_location {args} {
        tk_messageBox -message {Move Mouse Pointer and Press Enter...} -icon info
        set s [exec xdotool getmouselocation]
        set s [string map {":" " "} $s]
        # x, y, screen, window
        return [dict create {*}$s]
    }

    variable shcmd_pipe

    # TODO ui-states

    proc run_shell_command {shcmd} {
        variable shcmd_pipe

        set shcmd_pipe [open "|$shcmd 2>@1" r]
        fconfigure $shcmd_pipe \
            -blocking 0 -buffering full \
            -translation binary
        fileevent $shcmd_pipe readable "[namespace current]::shcmd_pipe_onread $shcmd_pipe"
    }

    proc shcmd_pipe_onread {ch} {
        if {[eof $ch]} {
            tout println "\n--- EOF: $ch ---"
            catch {close $ch}
        } else {
            set data [read $ch 100]
            tout print $data
        }
    }

    proc kill_shell_command {} {
        variable shcmd_pipe

        if {[string length $shcmd_pipe] == 0} {return}

        try {
            set pids [pid $shcmd_pipe]
            tout println "--- KILL: $pids ---"

            catch [list [namespace current]::kill_process $pids 1]
        } on error {err erropts} {
            tout println "--- WARN: $err ---"
        }

        set shcmd_pipe ""
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
    namespace export calc_by_from_to
    namespace ensemble create

    proc calc_by_from_to {from_xy to_xy} {
        lassign [split $from_xy ","] fromx fromy
        lassign [split $to_xy ","] tox toy
        return "[expr $tox - $fromx]x[expr $toy - $fromy]"
    }
}

namespace eval gui {
    namespace export makewin
    namespace ensemble create

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
            -command {shell run_shell_command "$gui::command"}
        button $c.btn_stop  -text Stop

        pack $c.btn_start -side left {*}$pads
        pack $c.btn_stop -side left {*}$pads

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

        tout println Ready.
    }

    proc select_output_filename {} {
        set file_path [tk_getSaveFile]

        if {$file_path eq ""} {
            puts "Canceled."
        } else {
            set "[namespace current]::output_filename" $file_path
        }
    }

    proc build_command {n1 n2 op} {
        foreach vname {seconds framerate output_filename from_xy to_xy} {
            variable $vname
        }
        variable command

        set geom "???"
        catch {
            set geom [::geom::calc_by_from_to $from_xy $to_xy]
        }

        set output_filename2 $output_filename
        catch {
            set output_filename2 [file tildeexpand $output_filename2]
        }

        set cmd "ffmpeg -f x11grab -video_size $geom -framerate $framerate -i $from_xy -t $seconds '$output_filename2'"
        set command "$cmd"

        ::tout println {--- [New command] ---}
        ::tout println "$cmd"
    }

    foreach namepart {from_xy to_xy} {
        set code [subst -nocommands {proc select_${namepart} {} {
            set d [::shell ask_mouse_location]
            set g "[dict get \$d x],[dict get \$d y]"
            variable $namepart
            set $namepart "\$g"
        }}]
        eval $code
    }
}


# main:

shell check_command ffmpeg xdotool

gui makewin


# TODO ${DISPLAY}.${SCREEN}
