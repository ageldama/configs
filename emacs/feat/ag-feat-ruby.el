
(use-package enh-ruby-mode :ensure t :pin melpa
  :config
  (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
  ;; (add-to-list 'auto-mode-alist '("\\.rb\\'" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist
               '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
  (when (fboundp 'robe-mode) (add-hook 'enh-ruby-mode-hook 'robe-mode))
  (when (fboundp 'yard-mode) (add-hook 'enh-ruby-mode-hook 'yard-mode))
  )


(use-package inf-ruby :ensure t :pin melpa
  :config
  (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
  ;; (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  ;;
  ;; (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter-and-focus)
  )


(use-package rbs-mode :ensure t)



(provide 'ag-feat-ruby)
