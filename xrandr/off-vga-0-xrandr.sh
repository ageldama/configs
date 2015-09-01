xrandr --output VGA-0 --off \
    --output HDMI-0 --off \
    --output LVDS --mode 1366x768

xmodmap -e 'keycode 66 = Control_L'
xmodmap -e 'clear Lock'
xmodmap -e 'add Control = Control_L'


