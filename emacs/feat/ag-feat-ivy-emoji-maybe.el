
(when (and (not (fboundp 'emoji-list))
           (member 'ivy features))
  (use-package ivy-emoji :ensure t
    :config (global-set-key (kbd "C-x 8 e") 'ivy-emoji)))


(provide 'ag-feat-ivy-emoji-maybe)
