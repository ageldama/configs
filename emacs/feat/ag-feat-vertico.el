
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode)
  :config
  (setq
   vertico-scroll-margin 0
   vertico-count 25
   vertico-cycle t
   vertico-resize t
   )
  )

;; (keymap-set vertico-map "?" #'minibuffer-completion-help)
;; (keymap-set vertico-map "M-RET" #'minibuffer-force-complete-and-exit)
;; (keymap-set vertico-map "M-TAB" #'minibuffer-complete)


(provide 'ag-feat-vertico)
