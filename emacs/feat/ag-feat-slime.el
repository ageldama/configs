(let ((hyperspec-path
       (glob-first-file "/usr/share/doc/hyperspec/"
                        "/usr/local/share/doc/clisp-hyperspec/HyperSpec/"
                        (expand-file-name "~/local/HyperSpec/"))))
  (when hyperspec-path
    (setq common-lisp-hyperspec-root hyperspec-path)))



(setq inferior-lisp-program "ros -Q run")


(use-package slime :ensure t :pin melpa
  :config  (setq slime-contribs '(slime-fancy))

  (add-hook 'slime-repl-mode-hook
            (lambda ()
              (when (featurep 'counsel)
                (local-set-key (kbd "C-c ,")
                               'counsel-slime-repl-history)
                (message "REPL History: C-c ,")
                )))

  )


(provide 'ag-feat-slime)
