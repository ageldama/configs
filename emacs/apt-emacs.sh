#!/bin/bash

set -x

# emacs-lucid : 한글 렌더링 버그 있는거 같아서 / Sun 13 Apr 12:44:21 BST 2025

FLAVOR=${1:-lucid}

DPKGS="
emacs-${FLAVOR}
emacs-common-non-dfsg
graphviz
plantuml
sqlite3
ditaa
elpa-use-package
elpa-f
elpa-s
elpa-org
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
elpa-yasnippet
elpa-yasnippet-snippets
elpa-web-mode
elpa-transient
elpa-writeroom-mode
elpa-olivetti
elpa-magit
elpa-js2-mode
elpa-helpful
elpa-vertico
elpa-marginalia
elpa-orderless
elpa-consult
"
# DEPRECATED elpa-counsel

DPKGS=$(echo $DPKGS | sed 's/\n//g')
echo "INSTALL: $DPKGS ..."
sudo apt install $DPKGS


# elpa-org-contrib (apt 검색해서 있을 때만)
apt search elpa-org-contrib && sudo apt install elpa-org-contrib


# emacs -v 실행해서 버전 30 이하일 때에만 eglot 설치
EMACS_LT_V30=$(emacs -nw -Q -batch --eval="(princ (version-list-< (version-to-list emacs-version) '(30 0)))")
if [[ "${EMACS_LT_V30}" == "t" ]]; then
    sudo apt install elpa-eglot
fi


# EOF.
