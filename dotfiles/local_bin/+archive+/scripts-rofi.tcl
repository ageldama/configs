#!/usr/bin/env tclsh9.0

namespace eval rofi {
    namespace export select_list ask_yn
    namespace ensemble create

    proc run_rofi {cmd lambda_write} {
        # NOTE: no stderr
        set fp [open "|$cmd" w+]
        set fp_pid [pid $fp]
        fconfigure $fp -translation binary -buffering none

        apply $lambda_write {*}[list $fp]

        set exitcode ""
        set output   ""

        try {
            set output   [string trim [read $fp]]
        } on error {err options} {
            puts stderr "<ERR> $err $options"
        }

        set procstat [::tcl::process status -wait $fp_pid]
        # puts "<$procstat>"

        set exitcode [lindex $procstat 1]
        if {![string is integer $exitcode]} {
            try {
                set exitcode [lindex [lindex $exitcode end] end]
                # puts $exitcode
            } on error {err options} {
                set exitcode -1 ;# idk.
            }
        }

        return [dict create output $output exitcode $exitcode pid $fp_pid]
    }

    proc ask_yn {args} {
        set defaults [dict create \
                          -prompt "Y/N?" \
                          -label_y "Yes" \
                          -label_n "No" \
                         ]
        set args_ [dict merge $defaults $args]

        dict with args_ {
            set cmd [list rofi -theme-str "window {width: 400px; height: 150px;}" -dmenu -p "${-prompt}" -sep "\\0" -format i]

            set res [[namespace current]::run_rofi $cmd \
                         [subst -nocommands {{fp} {
                             puts -nonewline \$fp "${-label_y}\x00"
                             puts -nonewline \$fp "${-label_n}\x00"
                             close \$fp write
                         }}]]

            if {[expr 0 == [dict get $res exitcode]]} {
                if {[expr 0 == [dict get $res output]]} {
                    return YES
                } else {
                    return NO
                }
            } else {
                return CANCELED
            }
        }
    }

    proc select_list {args} {
        set defaults [dict create \
                          -prompt "Select One" \
                          -selections {} \
                         ]
        set args_ [dict merge $defaults $args]

        dict with args_ {
            set cmd [list rofi -dmenu -p "${-prompt}" -kb-accept-alt "" -kb-custom-1 "Shift+Return" -sep "\\0"]

            set res [[namespace current]::run_rofi $cmd \
                         [subst -nocommands {{fp} {
                             set list_ [list ${-selections}]
                             foreach l \$list_ {
                                 puts -nonewline \$fp "\${l}\x00"
                             }
                             close \$fp write
                         }}]]

            switch -- [dict get $res exitcode] {
                "0"  {
                    return [list NORMAL [dict get $res output]]
                }

                "10" {
                    return [list ALT    [dict get $res output]]
                }

                default {
                    return
                }
            }
        }
    }
}


namespace eval options {
    namespace export OPT_LIST
    namespace ensemble create

    variable NO_DB_FILE  [file tildeexpand ~/.no-db-scripts-rofi]

    variable XTERM_CMD   "x-terminal-emulator -e"
    variable SCRIPT_DIRS [join [lmap {i} \
                                    {
                                        "~/local/scripts"
                                        "~/local/bin"
                                        "~/.screenlayout"
                                        "~/P/v3/bin"
                                    } {file tildeexpand $i}] ":"]
    variable DB_FILE     [file tildeexpand "~/.scripts-rofi.txt"]

    variable OPT_LIST \
        [list \
             "-e" [list type flag desc "Execute Selection" default 0] \
             "-s" [list type flag desc "Save Selection" default 0] \
             "-p" [list type flag desc "Print Selection" default 0] \
             "-S" [list type arg1 desc "SCRIPT DIRS (':'-separated)" default $SCRIPT_DIRS] \
             "-D" [list type arg1 desc "DB FILE" default $DB_FILE] \
             "-T" [list type arg1 desc "XTERM CMD" default $XTERM_CMD] \
             "-P" [list type flag desc "Dump history/freqs and exit" default 0] \
             "-h" [list type flag alts [list "-help" "-?" "--help" "--?"] default {Show Usage/Help} default 0] \
            ]

    proc db_file_access_allowed {} {
        variable NO_DB_FILE
        return [expr ![file exists $NO_DB_FILE]]
    }
}


namespace eval historydb {
    namespace export DB running_type_in_term running_type_noterm as_running_type
    namespace ensemble create

    proc running_type_in_term {} {
        return interm
    }

    proc running_type_noterm {} {
        return noterm
    }

    proc as_running_type {normal_or_alt} {
        switch -- $normal_or_alt {
            "ALT" {
                return [running_type_in_term]
            }
            "default" {
                return [running_type_noterm]
            }
        }
    }

    oo::class create Db {
        variable command_last_epochs
        variable command_running_types
        variable _db_file

        constructor {{db_file ""}} {
            my variable command_last_epochs
            my variable command_running_types
            my variable _db_file

            set _db_file $db_file
            set command_last_epochs {}
            set command_running_types {}
        }

        method chk_use_db_file {} {
            my variable _db_file

            if {[string length _db_file] == 0} {
                return ""
            }

            return $_db_file
        }

        method save {} {
            set db_file [my chk_use_db_file]
            if {![string is false $db_file]} {
                set fp [open $db_file w]
                my dump $fp
                close $fp
            }
        }

        method dump {ch} {
            my variable command_last_epochs
            my variable command_running_types
            set d [dict create epochs $command_last_epochs \
                       running_types $command_running_types ]
            puts $ch $d
        }

        method load {} {
            set db_file [my chk_use_db_file]
            if {![string is false $db_file]} {
                set fp [open $db_file r]
                set d [read $fp]
                close $fp

                try {
                    my variable command_last_epochs
                    my variable command_running_types
                    set command_last_epochs [dict getdef $d epochs {}]
                    set command_running_types [dict getdef $d running_types {}]
                } on error {err erropts} {
                    puts stderr "$err -- $erropts"
                }
            }
        }

        method get_last_epoch {cmd} {
            my variable command_last_epochs
            return [dict getdef $command_last_epochs $cmd 0]
        }

        method upd_last_epoch {cmd} {
            my variable command_last_epochs
            dict set command_last_epochs $cmd [clock seconds]
        }

        method incr_running_type {cmd running_type} {
            my variable command_running_types
            set val [dict getdef $command_running_types $cmd $running_type 0]
            incr val
            dict set command_running_types $cmd $running_type $val
        }

        method most_running_type {cmd} {
            my variable command_running_types
            set rts [dict getdef $command_running_types $cmd {}]
            set result [::historydb::running_type_noterm]
            set count  0
            dict for {rt c} $rts {
                if {$count < $c} {
                    set result $rt
                }
            }
            return $result
        }

        method compare_by_epoch {cmd_a cmd_b} {
            set epoch_a [my get_last_epoch $cmd_a]
            set epoch_b [my get_last_epoch $cmd_b]
            if {$epoch_a < $epoch_b} {
                return -1
            } elseif {$epoch_a > $epoch_b} {
                return 1
            }
            return 0
        }
    }
}


package require fileutil

namespace eval scriptfiles {
    namespace export ls_R ls_R_sorted split_paths
    namespace ensemble create

    proc file_executable {name} {
        if {[file isdir $name]} {
            return false
        }
        return [file executable $name]
    }

    proc ls_R {dirs} {
        set files {}

        foreach dir $dirs {
            foreach fn [fileutil::find $dir file_executable] {
                lappend files $fn
            }
        }

        return $files
    }

    proc ls_R_sorted {dirs db} {
        set files [[namespace current]::ls_R $dirs]
        set files [lsort -decreasing -command [list $db compare_by_epoch] $files]
        return $files
    }

    proc split_paths {paths} {
        return [split $paths ":"]
    }
}

package require cffi

namespace eval libc {
    cffi::Wrapper create LIBC [expr {$::tcl_platform(platform) eq "windows" ? "msvcrt.dll" : "libc.so.6"}]

    LIBC function execv int {
        path string
        argv pointer
    }

    LIBC function execvp int {
        path string
        argv pointer
    }

}

namespace eval posix {
    namespace export execv

    proc make_string_ptr_array_with_nullptr_ending {strings} {
        set n [llength $strings]
        set arr_ptr [cffi::memory allocate [expr {($n + 1) * [cffi::type size pointer]}]]

        set string_ptrs {}
        set i 0
        foreach s $strings {
            set p [cffi::memory fromstring $s]
            lappend string_ptrs $p
            cffi::memory set $arr_ptr pointer $p $i
            incr i
        }
        variable nullptr
        cffi::memory set $arr_ptr {pointer novaluechecks} NULL $i
        return [list $arr_ptr $string_ptrs]
    }

    proc free_string_array {arr_ptr string_ptrs} {
        foreach p $string_ptrs { cffi::memory free $p }
        cffi::memory free $arr_ptr
    }

    proc execv {path args} {
        lassign [make_string_ptr_array_with_nullptr_ending $args] arr_ptr string_ptrs
        libc::execv $path $arr_ptr
        free_string_array $arr_ptr $string_ptrs
        error "execv failed"
    }

    proc execvp {path args} {
        lassign [make_string_ptr_array_with_nullptr_ending \
                     [list $path {*}$args]] arr_ptr string_ptrs
        libc::execvp $path $arr_ptr
        free_string_array $arr_ptr $string_ptrs
        error "execv failed"
    }
}



# --- optp-1.0.tm

namespace eval optp {
    namespace export Parser

    oo::class create Parser {
        variable argv0 [info script]
        variable argv  {}
        variable opt_list {}
        variable parsed {}
        variable output

        constructor {args} {
            my variable opt_list argv0 argv output
            set opt_list [dict getdef $args options {}]
            set argv0 [dict getdef $args argv0 [info script]]
            set argv [dict getdef $args argv {}]
            set output [dict getdef $args output stderr]
        }

        method fill_defaults {} {
            set results {}
            my variable opt_list
            dict for {oname opt} $opt_list {
                dict set results $oname [dict getdef $opt default ""]
            }

            my variable parsed
            set parsed $results
        }

        method parse {} {
            my fill_defaults

            my variable parsed
            my variable argv
            for {set idx 0} {$idx < [llength $argv]} {incr idx} {
                set curr [lindex $argv $idx]

                set gotmatch false
                my variable opt_list
                dict for {oname opt} $opt_list {
                    set alts [dict getdef $opt alts {}]
                    set type [dict getdef $opt type flag]

                    if {[string equal $oname $curr] \
                            || [lsearch -exact $alts $curr] > -1} {
                        set gotmatch true
                        switch -- $type {
                            "flag" {
                                dict set parsed $oname 1
                            }

                            "arg1" {
                                incr idx
                                dict set parsed $oname [lindex $argv $idx]
                            }

                            "args" {
                                incr idx
                                dict lappend parsed $oname [lindex $argv $idx]
                            }

                            default {
                                error "Unsupported 'type'=${type}"
                            }
                        }
                    }
                }

                if {!$gotmatch} {
                    error "Option ($curr) cannot be matched!"
                }
            }
        }

        method get {key} {
            my variable parsed
            return [dict get $parsed {*}$key]
        }

        method dump {} {
            my variable parsed
            return $parsed
        }

        method show_usage {} {
            my variable argv0
            my variable opt_list
            my variable output
            puts $output "*** $argv0 ***\n"
            dict for {oname opt} $opt_list {
                switch -- [dict get $opt type] {
                    "arg1" {
                        puts -nonewline $output "<ARG1> ${oname}\n"
                    }

                    "args" {
                        puts -nonewline $output "<ARGS> ${oname}\n"
                    }

                    "flag" - default {
                        puts -nonewline $output "<FLAG> ${oname}\n"
                    }
                }

                if {[dict exists $opt alts]} {
                    puts -nonewline $output "\t(Aliases: [dict get $opt alts])\n"
                }

                if {[dict exists $opt default]} {
                    puts -nonewline $output "\t(Default: [dict get $opt default])\n"
                }

                if {[dict exists $opt desc]} {
                    puts -nonewline $output "\t[dict get $opt desc]\n"
                }

                puts $output "\n"
            }
        }
    }
}

package provide optp 1.0

# Local variables:
# mode: tcl
# End:



# --- MAIN: ------------------------------------------------------------

proc show_usage_and_exit {optp} {
    $optp show_usage
    set db_fileness [expr {[::options::db_file_access_allowed] ? "not-found" : "found"}]
    puts stderr "* NO_DB_FILE: ${::options::NO_DB_FILE} -- $db_fileness"
    exit -1
}

package require optp

set optp [::optp::Parser new \
              argv0 $argv0 argv $argv \
              options $::options::OPT_LIST]

$optp parse
if {[$optp get -h]} {
    show_usage_and_exit $optp
}

set db [::historydb::Db new]
if {[::options::db_file_access_allowed]} {
    set db [::historydb::Db new [$optp get -D]]
}
try {
    $db load
} on error {err erropts} {
    puts stderr "(db load : warn) $err" ;# -- $erropts"
}

if {[$optp get -P]} {
    $db dump stdout
    exit 0
}

set dirs [::scriptfiles split_paths [$optp get -S]]
set files [::scriptfiles ls_R_sorted $dirs $db]

set selection [::rofi select_list -prompt "Select a script to run (Shift-Enter == run-in-terminal)" -selections $files]

if {[string is false $selection]} {
    puts stderr "CANCELED"
} else {
    lassign $selection runalt cmd

    set selruntype [::historydb as_running_type $runalt]
    set mostruntype [$db most_running_type $cmd]
    set runtype $selruntype

    if {![string equal $selruntype $mostruntype]} {
        set to_most_runtype [rofi ask_yn \
                                 -prompt "MOSTLY = ${mostruntype}, but SELECTED = ${selruntype}" \
                                 -label_y "${mostruntype}" -label_n "${selruntype}" \
                                ]
        if {![string is false $to_most_runtype]} {
            set runtype $mostruntype
        }
    }

    $db incr_running_type $cmd $runtype
    $db upd_last_epoch $cmd

    if {[$optp get -s]} {
        $db save
    }

    if {[$optp get -p]} {
        puts stdout $cmd
    }

    if {[$optp get -e]} {
        if {[string equal $runtype [::historydb::running_type_in_term]]} {
            set cmd [list {*}[$optp get -T] {*}$cmd]
        }
        ::posix::execvp {*}$cmd
        # should never reach here
    }
}
