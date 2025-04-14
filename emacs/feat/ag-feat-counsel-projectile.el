

(when (fboundp 'projectile-find-file)
  (use-package counsel-projectile
    :ensure t :pin melpa
    :config
    (setq counsel-projectile-rg-initial-input
          '(projectile-symbol-or-selection-at-point))))



(provide 'ag-feat-counsel-projectile)
