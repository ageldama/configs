
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

(require 'ag-feat-common-lisp)


(provide 'ag-feat-sly)
