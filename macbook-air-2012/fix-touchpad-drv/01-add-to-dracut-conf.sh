sudo sh -c 'cat <<EOF >/etc/dracut.conf.d/touchpad.conf
add_drivers+="bcm5974"
EOF'

