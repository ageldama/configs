#!/bin/sh

DPKGS="
emacs-lucid
emacs-common-non-dfsg
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
elpa-counsel
elpa-yasnippet
elpa-web-mode
"

DPKGS=$(echo $DPKGS | sed 's/\n//g')
echo "INSTALL: $DPKGS ..."
sudo apt install $DPKGS

TODO=<<'EO_TODO'
clang flycheck-doc elpa-flx elpa-imenu-list libtext-multimarkdown-perl pandoc
org-mode-doc ditaa texlive-latex-extra texlive-fonts-recommended texinfo
elpa-ag exuberant-ctags elpa-solarized-theme elpa-use-package-chords
elpa-use-package-ensure-system-package elpa-bind-chord

clang flycheck-doc elpa-flx elpa-imenu-list libtext-multimarkdown-perl pandoc
python3-markdown org-mode-doc ditaa elpa-ag exuberant-ctags
elpa-solarized-theme elpa-use-package-chords
elpa-use-package-ensure-system-package elpa-bind-chord

elpa-vertico elpa-smex editorconfig elpa-marginalia markdown | discount |
libtext-markdown-perl elpa-yasnippet-snippets

EO_TODO

