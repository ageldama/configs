(use-package rust-mode :ensure t :pin melpa
  :config (add-hook 'rust-mode-hook
                    (lambda ()
                      (local-set-key (kbd "C-c <tab>") #'rust-format-buffer))))

(use-package cargo :ensure t :pin melpa
  :config (add-hook 'rust-mode-hook 'cargo-minor-mode))

(diminish 'cargo-minor-mode)

(use-package flycheck-rust :ensure t :pin melpa
  :config (with-eval-after-load 'rust-mode
            (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package toml-mode
  :ensure t :pin melpa)




(when (fboundp 'general-create-definer)
  (my-local-leader-def
    :keymaps 'rust-mode-map
    "c" (general-simulate-key "C-c C-c" :name cargo)

    "f" 'rust-format-buffer
    "F" 'rust-format-diff-buffer
    
    "r" 'rust-run
    "R" 'rust-run-release

    "t" 'rust-test

    "M-c" 'rust-compile

    "!" 'rust-run-clippy
    "M-!" 'rust-check

    "M-d" 'rust-dbg-wrap-or-unwrap
   ))

;;; LSP

(use-package lsp-mode :ensure t :pin melpa)
(use-package lsp-ui :ensure t :pin melpa)
(use-package dap-mode :ensure t :pin melpa)


(add-hook 'rust-mode-hook 'lsp)

(setq ;;gc-cons-threshold (* 100 1024 1024)
      ;;read-process-output-max (* 1024 1024)
      ;;treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast


(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-mode-hook #'lsp-treemacs-sync-mode)
  (require 'dap-cpptools))




;;; EOF
