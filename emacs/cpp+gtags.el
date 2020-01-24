;; DEPRECATED (defun my-c-c++-build-dir () (getenv "BUILD_DIR"))

;;; Debugger, CMake, Modern-CPP

(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))


;;; flycheck + clang-tidy
(require 'flycheck)

(use-package flycheck-clang-tidy
  :pin melpa :ensure t
  :after flycheck
  :hook
  (flycheck-mode . flycheck-clang-tidy-setup)
  :config
  ;;(flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-clang)
  (flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-gcc)
  )


;;; gtags : GNU Global
(use-package counsel-gtags :ensure t :pin melpa)


;;; flycheck + rtags backend.

(load-library (f-join langsup-base-path "compile-commands-json"))

(defcustom read-project-compile-commands #'read-compile-commands-resolved-by-rtags
  "compile-commands reader function"
  :type 'function)

;;; flycheck gcc/clang fixes
(defun flycheck-c/c++-clang-and-gcc-setup ()
  (interactive)
  ;; FIXME: no rtags
  (let ((inc-dirs  (compile-commands-json/include-dirs read-project-compile-commands)))
     ;;(message "Include-Dirs: %S" inc-dirs)
     (setq-local flycheck-clang-include-path inc-dirs)
     (setq-local flycheck-gcc-include-path inc-dirs)))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))


(defun my-c-c++-gtags-hook ()
  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)
  ;;
  (counsel-gtags-mode))


(defun my-c-c++-mode-hook ()
  (interactive)
  (my-c-c++-gtags-hook)
  (flycheck-c/c++-clang-and-gcc-setup)
  (flycheck-mode)
  ;;
  (c-c++-bind-key-map))

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook)


(defun gtags-local-defs ()
  (message "Using GNU Global")
  (my-local-leader-def :keymaps 'c-mode-base-map
    "," 'counsel-gtags-go-backward
    "." 'counsel-gtags-dwim

    "g" '(:ignore t :which-key "gtags")
    "g d" 'counsel-gtags-find-definition
    "g r" 'counsel-gtags-find-reference
    "g s" 'counsel-gtags-find-symbol
    "g c" 'counsel-gtags-create-tags
    "g u" 'counsel-gtags-update-tags
    ))

(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (gtags-local-defs)))


;;; EOF
