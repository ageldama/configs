#!/usr/bin/env wish8.6

package require tkdnd

if {[llength $argv] < 1} {
    exit 1
}

set file_paths [lmap fn $argv {file normalize $fn}]
set file_paths [lmap path $file_paths {subst "file://$path"}]
set file_paths [join $file_paths "\n"]

label .drag_me -text "Drag This:\n $file_paths" -bg cyan  -font {Monospace 16 bold}
pack .drag_me -padx 10 -pady 10

tkdnd::drag_source register .drag_me text/uri-list

bind .drag_me <<DragInitCmd>> [list trigger_drag $file_paths]

bind .drag_me <Button-2> { exit }
bind .drag_me <Button-3> { exit }
bind . <Escape> { exit }

proc trigger_drag {file_paths} {
    return [list copy text/uri-list $file_paths]
}
