;;; eldoc
(use-package eldoc :ensure t :pin melpa :diminish eldoc-mode
  :config (add-hook 'prog-mode-hook 'eldoc-mode))
