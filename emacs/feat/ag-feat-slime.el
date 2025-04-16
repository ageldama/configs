(let ((hyperspec-path
       (glob-first-file "/usr/share/doc/HyperSpec"
                        (expand-file-name "~/local/HyperSpec"))))
  (when hyperspec-path
    (setq common-lisp-hyperspec-root hyperspec-path)))



(setq inferior-lisp-program "ros -Q run")


(use-package slime :ensure t :pin melpa
  :config  (setq slime-contribs '(slime-fancy)))


(provide 'ag-feat-slime)
