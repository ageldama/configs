(use-package realgud :ensure t :pin melpa)

(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

;; (load-file (s-concat langsup-base-path "/goog-c-style.el"))


