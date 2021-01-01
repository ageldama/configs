(use-package tuareg
  :ensure t :pin melpa
  :config
  (add-hook 'tuareg-mode-hook #'electric-pair-local-mode)
  ;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
  (setq auto-mode-alist
        (append '(("\\.ml[ily]?$" . tuareg-mode)
                  ("\\.topml$" . tuareg-mode))
                auto-mode-alist)))

;; Merlin configuration

(use-package merlin
  :ensure t :pin melpa
  :config
  (setq merlin-command 'opam)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (add-hook 'merlin-mode-hook #'company-mode)
  (setq merlin-error-after-save nil))

;; utop configuration

(use-package utop
  :ensure t :pin melpa
  :config
  (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
  (add-hook 'tuareg-mode-hook 'utop-minor-mode))

(use-package flycheck-ocaml :pin melpa :ensure t
  :config
  (setq merlin-error-after-save nil)
  (flycheck-ocaml-setup))

(use-package merlin-eldoc
  :ensure t :pin melpa
  :hook ((reason-mode tuareg-mode caml-mode) . merlin-eldoc-setup))
