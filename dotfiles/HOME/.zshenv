export PATH=~/local/bin:$PATH


if [ -n "$DESKTOP_SESSION" ];then
  eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
  export SSH_AUTH_SOCK
fi

if [[ -f $XDG_RUNTIME_DIR/keyring/ssh ]]; then
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh
fi



