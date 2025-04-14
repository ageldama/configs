
(use-package evil-vimish-fold
  :ensure t :pin melpa
  :after vimish-fold
  :hook ((prog-mode conf-mode text-mode) . evil-vimish-fold-mode))


(provide 'ag-feat-evil-vimish-fold)
