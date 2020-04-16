(use-package rust-mode :ensure t :pin melpa
  :config (add-hook 'rust-mode-hook
                    (lambda ()
                      (local-set-key (kbd "C-c <tab>") #'rust-format-buffer))))

(use-package cargo :ensure t :pin melpa
  :config (add-hook 'rust-mode-hook 'cargo-minor-mode))

(use-package flycheck-rust :ensure t :pin melpa
  :config (with-eval-after-load 'rust-mode
            (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package toml-mode
  :ensure t :pin melpa)

