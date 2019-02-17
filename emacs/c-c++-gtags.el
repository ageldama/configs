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

(load-library (f-join langsup-base-path "compile-commands-json"))

(defun flycheck-c/c++-clang-or-gcc-by-cmake-build-path ()
  (interactive)
  (message "bound? %S -- %S" (boundp 'cmake-build-path) projectile-project-root)
  (when (boundp 'cmake-build-path)
    (message "cmake-build-path -- %S" cmake-build-path)
    (let ((inc-dirs  (compile-commands-json/include-dirs cmake-build-path)))
      (message "%S" inc-dirs)
      (setq-local flycheck-clang-include-path inc-dirs)
      (setq-local flycheck-gcc-include-path inc-dirs))))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)
(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(defun my-c-c++-mode-hook2 ()
  (interactive)
  ;; TODO: (setq flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck))
  ;; TODO: (flycheck-select-checker 'c/c++-clang-tidy)
  (flycheck-c/c++-clang-or-gcc-by-cmake-build-path)
  (flycheck-mode))

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook2)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook2)


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
