(use-package slime :ensure t :pin melpa
  :config  (setq inferior-lisp-program (expand-file-name "sbcl")
		 slime-contribs '(slime-fancy)))
