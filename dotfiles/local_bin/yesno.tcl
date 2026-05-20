#!/usr/bin/env tclsh

set q "really???"
if { $argc > 0 } {
    set q [lindex $argv [expr $argc - 1]]
}

set ch [open [list | rofi {*}[list \
  -theme-str "window { width: 200px; height: 150px; }" \
  -dmenu -p "$q" -eh 2 -markup-rows -format i]] rb+]

fconfigure $ch -buffering none

puts $ch "<span size='x-large' weight='heavy'>Yes</span>"
puts $ch "<span size='x-large' weight='heavy'>No</span>"
close $ch write ;# 이렇게 해야 rofi 렌더링 즉시.

proc reader {ch} {
  catch {
    set s [read -nonewline $ch]
    close $ch
    exit $s
  }
  exit -1
}

fileevent $ch readable [list reader $ch]

vwait forever
