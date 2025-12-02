
(use-package slime :ensure t :pin melpa
  :config  (setq slime-contribs '(slime-fancy))

  ;; (add-hook 'slime-repl-mode-hook
  ;;           (lambda ()
  ;;             (when (featurep 'counsel)
  ;;               (local-set-key (kbd "C-c ,")
  ;;                              'counsel-slime-repl-history)
  ;;               (message "REPL History: C-c ,")
  ;;               )))

  )


(require 'ag-feat-common-lisp)


(provide 'ag-feat-slime)
