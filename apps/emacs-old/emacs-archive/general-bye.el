;;; 2022 05may 13fri.


;;; General -- Leading Keybinder
(use-package general :ensure t :pin melpa)

(general-create-definer my-global-leader-def
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "<f12>")

(general-create-definer my-local-leader-def
  :states '(normal visual insert emacs)
  :prefix "SPC SPC"
  :non-normal-prefix "<f12> SPC"
  :prefix-name "mm")




;;;---------------------------------------------------------------------- 

(my-global-leader-def
  "f" 'files-dirs-hs/body
  ;; "$" 'eshell-toggle
  "$" 'shell-pop

  ;;"/" 'swiper-isearch-thing-at-point

  ;;"RET" 'swiper
  ;;"RET" 'counsel-M-x
  ;;"M-RET" 'eval-expression

  "b"    'ibuffer
  "TAB"  'ivy-switch-buffer

  "?" 'counsel-descbinds

  "k"    'counsel-yank-pop
  "C-k"  'kill-current-buffer

  "m" 'counsel-mark-ring
  "i" 'counsel-imenu

  "~"    '(:ignore t :which-key "misc")
  "~ p"  'counsel-list-processes
  "~ b"  'counsel-bookmark
  "~ d"  'sdcv-search-input
  "~ s"  'delete-trailing-whitespace
  "~ G"  'garbage-collect

  "e"   'flycheck-next-error
  "M-e" 'flycheck-previous-error
  "C-e" 'hydra-flycheck/body

  "M-q" 'hydra-misc-toggles/body

  "o"    '(:ignore t :which-key "org")
  "o a"  'org-agenda
  "o c"  'org-capture
  "o M-c"  'org-capture-open
  "o M-p"  '(lambda () (interactive) (find-file "~/P/v3/PLAN.org"))
  "o d"  'diary/new-or-open-org-file

  ;; windows
  "M-w" 'hydra-windbuf/body
  "M-SPC" 'other-window

  "*" 'ace-swap-window
  "%" 'window-toggle-split-direction
  "_" 'split-window-below
  "|" 'split-window-right
  "q" 'delete-window

  "<left>" 'windmove-left
  "<right>" 'windmove-right
  "<up>" 'windmove-up
  "<down>" 'windmove-down

  "S-<left>" 'buf-move-up
  "S-<right>" 'buf-move-right
  "S-<up>" 'buf-move-up
  "S-<down>" 'buf-move-down

  "=" 'balance-windows
  "+" 'enlarge-window
  "-" 'shrink-window
  ">" 'enlarge-window-horizontally
  "<" 'shrink-window-horizontally

  ;; jumps / registers
  "r" (general-simulate-key "C-x r" :name regs-marks)

  ;; LSP
  ;;"l" (general-simulate-key "s-l" :name lsp)
  
  ;; avy: Moved to `M-g
  "l"   'avy-goto-line
  "w"   'avy-goto-word-0
  ;; "j"   'avy-goto-char-timer
  ;; "M-j" 'avy-goto-char
  ;; "C-j" 'hydra-avy-goto/body
  ;; "C-t" 'avy-pop-mark

  ;; projectile
  "p" 'projectile-find-file-dwim
  "P" 'projectile-commander

  ;; magit
  "g"      'magit-status
  "C-S-g"  'omz-ish/gwip

  ;; moonshot
  "x" 'hydra-moonshot/body

  ;; undo-tree
  "u" 'undo-tree-visualize

  ;; string-inflection
  "M-i" 'hydra-string-inflection/body

  ;; xdg-open, browse-url etc.
  "M-x"      '(:ignore t :which-key "external-open")
  "M-x RET"  'xdg-open-current-region
  "M-x ."    'xdg-open-current-buffer
  "M-x g"    'google-it

  ;; vars
  "M-v"    '(:ignore t :which-key "vars")
  "M-v d"  'add-dir-local-variable 
  "M-v f"  'add-file-local-variable
  "M-v p"  'add-file-local-variable-prop-line
   

  ;;"'" '(general-simulate-key "C-'" :name mm)

  "RET" 'yas-insert-snippet
  "M-y" 'hydra-yas/body
  )
