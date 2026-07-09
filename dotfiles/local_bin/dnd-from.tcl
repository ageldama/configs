#!/usr/bin/env wish8.6

package require tkdnd

if {[llength $argv] < 1} {
    exit 1
}

set file_path [file normalize [lindex $argv 0]]


label .drag_me -text "Drag This:\n $file_path" -bg cyan  -font {Monospace 16 bold}
pack .drag_me -padx 10 -pady 10

tkdnd::drag_source register .drag_me text/uri-list

bind .drag_me <<DragInitCmd>> [list trigger_drag $file_path]

bind .drag_me <Button-2> { exit }
bind .drag_me <Button-3> { exit }
bind . <Escape> { exit }

proc trigger_drag {file_path} {
    set uri "file://$file_path"
    return [list copy text/uri-list $uri]
}
