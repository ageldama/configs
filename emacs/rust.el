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
