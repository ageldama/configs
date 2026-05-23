;;; undo-tree
(use-package undo-tree
  :diminish 
  :ensure t
  :init (global-undo-tree-mode)
  :config (setq undo-tree-auto-save-history nil))

