
(use-package ivy-emoji :ensure t
  :after (ivy)
  :config (global-set-key (kbd "C-x 8 e <tab>") 'ivy-emoji)
  )


(provide 'ag-feat-ivy-emoji-maybe)
