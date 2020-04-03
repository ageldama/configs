(use-package yaml-mode :ensure t :pin melpa)

(use-package enh-ruby-mode :ensure t :pin melpa
  :config
  (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
  )


(use-package robe :ensure t :pin melpa
  :config
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (eval-after-load 'company
  '(push 'company-robe company-backends)))
