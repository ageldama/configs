(use-package projectile :ensure t :pin melpa)

(use-package irony :ensure t :pin melpa)

(use-package s :ensure t)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(add-hook 'irony-mode-hook (lambda ()
                             (irony-cdb-json-add-compile-commands-path (projectile-project-root)
                                                                       (s-concat (getenv "BUILD_DIR")
                                                                                 "/compile_commands.json"))))


(use-package company :ensure t :pin melpa)

(use-package company-irony :ensure t :pin melpa
  :config (add-to-list 'company-backends 'company-irony))

(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)



(use-package irony-eldoc :ensure t :pin melpa)

(add-hook 'irony-mode-hook #'irony-eldoc)
