(use-package helm-projectile :ensure t :pin melpa
  :config (progn (setq projectile-completion-system 'helm)
                 (helm-projectile-on)))

