#!/bin/sh

# emacs-common-non-dfsg

DPKGS="
emacs-lucid
graphviz
plantuml
sqlite3
ditaa
elpa-use-package
elpa-f
elpa-s
elpa-org
elpa-org-contrib
elpa-modus-themes
elpa-hydra
elpa-which-key
elpa-smart-mode-line
elpa-avy
elpa-ace-window
elpa-ace-window
elpa-eshell-up
elpa-wgrep
elpa-expand-region
elpa-undo-tree
elpa-evil
elpa-diminish
elpa-exec-path-from-shell
elpa-company
elpa-editorconfig
elpa-hl-todo
elpa-markdown-mode
elpa-projectile
elpa-embark
elpa-vimish-fold
elpa-flycheck
elpa-counsel
elpa-yasnippet
elpa-yasnippet-snippets
elpa-web-mode
"

DPKGS=$(echo $DPKGS | sed 's/\n//g')
echo "INSTALL: $DPKGS ..."
sudo apt install $DPKGS

