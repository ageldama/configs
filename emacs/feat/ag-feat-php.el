(use-package php-mode :ensure t :pin melpa
  :config
  (ag-reinit/add-as-interactive
   (when (boundp 'eglot-server-programs)
     (add-to-list 'eglot-server-programs
                  '(php-mode . ("phpactor.phar" "language-server")))))
  )


(provide 'ag-feat-php)
