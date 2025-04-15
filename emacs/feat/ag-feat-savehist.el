
(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :config
  (setq
   savehist-file (locate-user-emacs-file "savehist")
   history-length 100
   history-delete-duplicates t
   savehist-save-minibuffer-history t
   )
  (add-to-list 'savehist-additional-variables 'kill-ring))



(provide 'ag-feat-savehist)
