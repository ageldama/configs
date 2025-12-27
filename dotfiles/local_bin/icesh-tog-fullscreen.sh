#!/bin/sh
(icesh -f properties | grep _NET_WM_STATE_FULLSCREEN && icesh -f restore) || icesh -f fullscreen

