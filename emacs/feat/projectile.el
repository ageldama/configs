;;; projectile
(use-package projectile :pin melpa
  :config
  (progn (projectile-global-mode)
         ;;(diminish 'projectile-mode)
         (setq projectile-mode-line-prefix " Prj")
         (define-key projectile-mode-map (kbd "C-c p")
           'projectile-command-map)

         ;; for xref :
         (cl-defmethod project-roots ((project (head projectile)))
           (list (cdr project)))
         ))
