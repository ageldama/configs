(defun sly-no-company-mode ()
  (company-mode -1))

(use-package sly :ensure t :pin melpa
  :config (setq inferior-lisp-program (expand-file-name "~/local/sbcl/run-sbcl.sh")
                sly-ignore-protocol-mismatches t)
  (add-hook 'sly-mode-hook #'sly-no-company-mode)
  (add-hook 'sly-db-hook #'sly-no-company-mode))
