(use-package google-c-style :ensure t :pin melpa
  :config (progn (add-hook 'c-mode-hook 'google-set-c-style)
                 (add-hook 'c++-mode-hook 'google-set-c-style)))

