
(use-package smart-mode-line :ensure t :pin melpa
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'dark nil t)
  )


;;;
(provide 'ag-feat-smart-mode-line)
