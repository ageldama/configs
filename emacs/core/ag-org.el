
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
            ))


(setq org-log-done 'time)
(setq org-startup-with-inline-images t)


;;;
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))


;;;
(provide 'ag-org)
