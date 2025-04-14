
(use-package ace-window :ensure t :pin melpa
  :config
  (global-set-key (kbd "C-x o") 'ace-window)
  (global-set-key (kbd "C-x O") 'aw-show-dispatch-help)
  )


;;;
(provide 'ag-feat-ace-window)
