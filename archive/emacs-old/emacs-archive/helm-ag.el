
;; helm-ag -- the-silver-searcher
(use-package helm-ag :ensure t :pin melpa
  :config (setq helm-ag-insert-at-point 'symbol
                ;; helm-ag-base-command "rg --vimgrep --no-heading --smart-case"
                ))

(defun helm-ag-maybe-projectile ()
  (interactive)
  (if (projectile-project-p)
      (helm-projectile-ag)
    (helm-ag)))
