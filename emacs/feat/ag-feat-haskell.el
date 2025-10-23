
(use-package haskell-mode :ensure t :pin melpa
  :config
  (require 'ob-haskell)
  (add-to-list 'org-babel-load-languages
               '(haskell . t))
  (org-babel-do-load-languages 'org-babel-load-languages
                               org-babel-load-languages))


(provide 'ag-feat-haskell)
