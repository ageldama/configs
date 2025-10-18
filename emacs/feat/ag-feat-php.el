(use-package php-mode :ensure t :pin melpa
  :config
  (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

  (ag-reinit/add-as-interactive

   ;; https://github.com/phpactor/phpactor
   (when (require 'eglot nil t)
     (add-to-list 'eglot-server-programs
                  '(php-mode . ("phpactor.phar" "language-server")))))
  )


(use-package ob-php :pin melpa :ensure t
  :config (require 'ob-php)
  (add-to-list 'org-babel-load-languages
               '(php . t))
  (org-babel-do-load-languages 'org-babel-load-languages
                               org-babel-load-languages))


(provide 'ag-feat-php)
