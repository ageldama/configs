#!/usr/bin/env tclsh

set q "really???"

set ch [open [list | rofi {*}[list \
  -theme-str "window { width: 200px; height: 150px; }" \
  -dmenu -p "$q" -eh 2 -markup-rows -format i]] rb+]

fconfigure $ch -buffering none

puts $ch "<span size='x-large' weight='heavy'>Yes</span>"
puts $ch "<span size='x-large' weight='heavy'>No</span>"
# flush ch

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
