(use-package slime :ensure t :pin melpa
  :config  (setq inferior-lisp-program (expand-file-name "~/local/sbcl/run-sbcl.sh")
		 slime-contribs '(slime-fancy)))
