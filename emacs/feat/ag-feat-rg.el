;;; rg / ripgrep

(use-package rg :ensure t
  :config (progn
            (global-set-key (kbd "M-s C-f") 'rg)
            (global-set-key (kbd "M-s g M-r") 'rg))
  )


(provide 'ag-feat-rg)
