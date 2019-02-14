(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(use-package counsel-gtags :ensure t :pin melpa
  :config
  (add-hook 'c-mode-hook 'counsel-gtags-mode)
  (add-hook 'c++-mode-hook 'counsel-gtags-mode)

  (with-eval-after-load 'counsel-gtags
    (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
    (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
    (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
    (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
    (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)))

(use-package realgud :ensure t :pin melpa)

;;; flycheck + clang-tidy.
(use-package flycheck-clang-tidy :ensure t :pin melpa)

(defun my-c-c++-mode-hook ()
  (interactive)
  (setq flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck))
  (flycheck-select-checker 'c/c++-clang-tidy)
  (flycheck-mode))

(progn
  (add-hook 'c-mode-hook 'my-c-c++-mode-hook)
  (add-hook 'c++-mode-hook 'my-c-c++-mode-hook))

;; TODO: select build-path for `flycheck-clang-tidy-build-path`?

;; (use-package flycheck-clangcheck :ensure t :pin melpa)

(use-package clang-format :ensure t :pin melpa
  :config
  (defun clang-format-dwim ()
    (interactive)
    (if mark-active
        (call-interactively #'clang-format-region)
      (clang-format-buffer))))

;;;
(when (fboundp 'general-create-definer)
  (my-local-leader-def :keymaps 'c-mode-base-map
    "," 'counsel-gtags-go-backward
    "." 'counsel-gtags-dwim

    "g" '(:ignore t :which-key "gtags")
    "g d" 'counsel-gtags-find-definition
    "g r" 'counsel-gtags-find-reference
    "g s" 'counsel-gtags-find-symbol
    "g c" 'counsel-gtags-create-tags
    "g u" 'counsel-gtags-update-tags

    "f" 'clang-format-dwim
    ))

;;;EOF.
