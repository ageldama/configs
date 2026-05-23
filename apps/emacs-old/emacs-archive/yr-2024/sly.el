;;; Sly + Company integration is unstable,
;;; (NOT ANYMORE! `C-g' during `company-mode' completion, Emacs hangs)
;;;
;;; Use `C-M-i' or `M-Tab' instead.
(defun sly-no-company-mode ()
  (company-mode -1))

(use-package sly :ensure t :pin melpa
  :config (setq inferior-lisp-program (executable-find "sbcl")
                sly-ignore-protocol-mismatches t)
  (dolist (i '(sly-mode-hook sly-db-hook))
    (add-hook i (lambda () (company-mode +1))))
  ;;(add-hook 'sly-mode-hook #'sly-no-company-mode)
  ;;(add-hook 'sly-db-hook #'sly-no-company-mode)
  )

(bind-company-local-key 'sly-mrepl-mode-hook (kbd "<C-tab>"))

(defun sly-start-qlot (directory)
  (interactive (list (read-directory-name "Project directory: ")))
  (sly-start :program "qlot"
             :program-args '("exec" "ros" "-S" "." "run")
             :directory directory
             :name 'qlot
             :env (list (concat "PATH=" (mapconcat 'identity exec-path ":")))))
