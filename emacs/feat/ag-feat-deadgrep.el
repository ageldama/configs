;;; deadgrep

(use-package deadgrep :ensure t :pin melpa
  :config (global-set-key (kbd "M-s C-f") 'deadgrep))


(use-package wgrep-deadgrep :ensure t :pin melpa
  :config
  (autoload 'wgrep-deadgrep-setup "wgrep-deadgrep")
  (add-hook 'deadgrep-finished-hook 'wgrep-deadgrep-setup))


(provide 'ag-feat-deadgrep)
