

;;; Debugger, CMake, Modern-CPP

(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(load-file (s-concat langsup-base-path "/goog-c-style.el"))


;;; flycheck + clang-tidy
(require 'flycheck)


;;; LSP

(use-package lsp-mode :ensure t :pin melpa)
(use-package lsp-ui :ensure t :pin melpa)
(use-package dap-mode :ensure t :pin melpa)


(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq ;;gc-cons-threshold (* 100 1024 1024)
      ;;read-process-output-max (* 1024 1024)
      ;;treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast


(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools))




;;; EOF
