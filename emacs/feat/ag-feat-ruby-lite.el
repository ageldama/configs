

(add-to-list 'auto-mode-alist '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . ruby-mode))


(use-package rbs-mode :ensure t)

(use-package inf-ruby :ensure t :pin melpa
  :config
  (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
  ;; (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  ;;
  ;; (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter-and-focus)
  )



(when (fboundp 'defhydra)
  (eval '(defhydra hydra-lang-ruby ()
           "ruby"

           ("f" (lambda () (interactive) (compile (format "rubocop -a %s" (buffer-file-name)))) "rubocop -a" :exit t)

           ("SPC" nil)))

  (require 'ag-lang-mode)
  (lang-mode-hydra-set 'ruby-mode-hook 'hydra-lang-ruby/body))




(provide 'ag-feat-ruby-lite)
