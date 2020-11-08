mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/emacsclient.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Emacsclient
GenericName=Text Editor
Comment=View and edit files
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
Exec=/usr/bin/emacsclient -c %F
Icon=/usr/share/icons/hicolor/scalable/apps/emacs.svg
Type=Application
Terminal=false
Categories=Utility;Development;TextEditor;
StartupWMClass=Emacs
EOF
