(use-package sly :ensure t :pin melpa
  :config  (setq inferior-lisp-program
                 (expand-file-name
                  "~/local/sbcl-1.4.9-x86-64-linux/run-sbcl.sh")))


