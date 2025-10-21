(let ((hyperspec-path
       (glob-first-file "/usr/share/doc/hyperspec/"
                        (expand-file-name "~/local/HyperSpec/"))))
  (when hyperspec-path
    (setq common-lisp-hyperspec-root hyperspec-path)))




(setq inferior-lisp-program
      (cond
       ((executable-find "ros") "ros -Q run")
       ((executable-find "sbcl") "sbcl")))



(use-package sly :ensure t :pin melpa
  :config
  (sly-setup)
  (sly-enable-contrib 'sly-fancy)

  (add-hook 'sly-mrepl-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c ,")
                               'isearch-backward)
              (message "REPL History: C-c ,")))

  )


(provide 'ag-feat-sly)
