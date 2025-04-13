(use-package slime :ensure t :pin melpa
  :config  (setq inferior-lisp-program "sbcl"
		 slime-contribs '(slime-fancy)))
