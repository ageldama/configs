synclient TouchpadOff=0

xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Tapping Enabled' 1 || \
xinput set-prop --type=int --format=8 \
  "ETPS/2 Elantech Touchpad" \
  "Synaptics Tap Action" 1 1 1 2 1 3

COMMENT=<<'EO_COMMENT'
   1 1 1 2 1 3
   : :
   1 1 - enable single-finger tap and assign it to Button1 (left-click)
       1 2 - enable double-finger tap and assign it to Button2 (right-click)
           1 3 - enable gesture for middle-click and assign it to Button3 (middle-click)
EO_COMMENT
