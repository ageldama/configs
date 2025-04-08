#!/usr/bin/env wish


set question "really?"

if {[llength $argv] > 0} {
  set question [lindex $argv 0]
}

wm withdraw .
wm title . "(Q) $question"
set answer [tk_messageBox -message $question -type yesno -icon question]

if {$answer == yes} {
  exit 0
} else {
  exit -1
}
