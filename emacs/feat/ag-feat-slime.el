(use-package slime :ensure t :pin melpa
  :config  (setq inferior-lisp-program "ros -Q run"
                 slime-contribs '(slime-fancy)))


(provide 'ag-feat-slime)
