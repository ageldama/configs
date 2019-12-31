;;; https://github.com/racer-rust/racer
;;;
;;; https://github.com/racer-rust/emacs-racer#installation
;;;
;;; Better and Reliabler than RLS + LSP. (2019-Dec-31, jhyun)
;;;

(use-package toml-mode
  :ensure t :pin melpa)

(use-package rust-mode
  :ensure t :pin melpa
  ;;:hook (rust-mode . lsp)
  )

;; Add keybindings for interacting with Cargo
(use-package cargo
  :ensure t :pin melpa
  :diminish 'cargo-minor-mode
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :ensure t :pin melpa
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package racer :ensure t :pin melpa
  :diminish
  :config (progn (add-hook 'rust-mode-hook #'racer-mode)
                 (add-hook 'racer-mode-hook #'eldoc-mode)
                 (add-hook 'racer-mode-hook #'company-mode)
                 ))




(when (fboundp 'general-create-definer)
  (my-local-leader-def
    :keymaps 'rust-mode-map
    "?" 'racer-describe
    "c" (general-simulate-key "C-c C-c" :name cargo)
   ))


;;; To install `racer':
;; 1) rustup toolchain add nightly
;; 2) cargo +nightly install racer
