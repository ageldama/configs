;;; jsx
(use-package rjsx-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.jsx" . rjsx-mode)))
