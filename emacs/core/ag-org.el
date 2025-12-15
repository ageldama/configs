
(use-package org :ensure t :pin org)

;; (use-package org-contrib :ensure t )


(require 'org-crypt)
(org-crypt-use-before-save-magic)

(setq org-tags-exclude-from-inheritance '("crypt")
      ;; org-crypt-key "ageldama@gmail.com")
      org-confirm-babel-evaluate t
      )

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (awk . t)
   (perl . t)
   (python . t)
   (dot . t)
   (plantuml . t)
   (ditaa . t)
   (org . t)
   (sqlite . t)
   (C . t)
   (gnuplot . t)
   (table . t)
   (makefile . t)
   (eshell . t)
   (calc . t)
   (ruby . t)
   (sql . t)
   ))


(add-hook 'org-mode-hook
          (lambda ()
            (when (fboundp 'flycheck-mode)
              (flycheck-mode -1))
            ;;
            (setq truncate-lines nil
                  org-adapt-indentation t
                  )
            (auto-fill-mode +1)
            (electric-quote-local-mode)
            ))


(setq org-log-done 'time)
(setq org-startup-with-inline-images t)




(setq org-agenda-files (append (file-expand-wildcards "~/P/v3/AGENDA*.org*")
                               (file-expand-wildcards "~/P/v3/PLAN*.org_archive"))

      org-agenda-include-diary t
      diary-file (expand-file-name "~/P/v3/diary/+emacs-diary+/curr")

      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))


;;;
(provide 'ag-org)
