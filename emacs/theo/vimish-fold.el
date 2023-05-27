(use-package vimish-fold :ensure t :pin melpa
  :after evil
  :config (progn (vimish-fold-global-mode +1)
                 (global-set-key (kbd "C-c @ t") 'vimish-fold-toggle)
                 (global-set-key (kbd "C-c @ f") 'vimish-fold)
                 (global-set-key (kbd "C-c @ d") 'vimish-fold-delete)))
