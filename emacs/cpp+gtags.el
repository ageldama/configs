(defun my-c-c++-build-dir () (getenv "BUILD_DIR"))

(defun parse-compile-commands-json-inc-dirs (dir)
  (let* ((fn (s-concat dir "/compile_commands.json"))
         (inc-dirs
          (shell-command-to-string (s-concat "go-parse-compile-cmds " fn))))
    (mapcar (lambda (s) (if (s-prefix? "/" s) s
                          (s-concat dir "/" s)))
            (s-split "\n" inc-dirs))))

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
  (flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-clang)
  (flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-gcc)
  )


;;; gtags : GNU Global
(use-package counsel-gtags :ensure t :pin melpa)


;;; flycheck gcc/clang fixes
(defvar my-c-c++-touched nil)

(defun flycheck-c/c++-setup ()
  (interactive)
  (let ((inc-dirs  (parse-compile-commands-json-inc-dirs
                    (my-c-c++-build-dir))))
    (message "Include-Dirs: %S" inc-dirs)
    (setq-local flycheck-clang-include-path inc-dirs)
    (setq-local flycheck-gcc-include-path inc-dirs)
    (setq-local flycheck-clang-tidy-build-path
                (my-c-c++-build-dir)))
  (setq-local my-c-c++-touched t)
  (ignore-errors
    (flycheck-buffer)))



;;;
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
  (unless my-c-c++-touched
    (run-with-timer 0.5 nil #'flycheck-c/c++-setup))
  (flycheck-mode)
  ;;
  (c-c++-bind-key-map))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

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
    "g !" 'flycheck-c/c++-setup
    ))

(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (gtags-local-defs)))


;;; EOF
