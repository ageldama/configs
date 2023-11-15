
;;; LSP

(use-package lsp-mode :ensure t :pin melpa)
(use-package lsp-ui :ensure t :pin melpa)
(use-package dap-mode :ensure t :pin melpa)

(setq ;;gc-cons-threshold (* 100 1024 1024)
      ;;read-process-output-max (* 1024 1024)
      ;;treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast


(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;;; EOF.
