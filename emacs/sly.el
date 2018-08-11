(use-package sly :ensure t :pin melpa
  :config  (setq inferior-lisp-program
                 (expand-file-name "~/local/sbcl/run-sbcl.sh")))


