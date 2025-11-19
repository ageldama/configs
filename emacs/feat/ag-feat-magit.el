(use-package magit :ensure t :pin melpa
  :config
  (require 'ag-hydra--main)
  (add-to-list 'hydra-mini/++extras
               '("g" magit-status "magit" ))
  )

(provide 'ag-feat-magit)
