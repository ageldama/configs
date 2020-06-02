(defun my-c-c++-build-dir () (getenv "BUILD_DIR"))

(defun parse-compile-commands-json-inc-dirs (dir)
  (let* ((fn (s-concat dir "/compile_commands.json"))
         (inc-dirs
          ;; https://github.com/ageldama/go-parse-compile-cmds
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





;;; RMSBolt
(use-package rmsbolt :ensure t :pin melpa)

(load-library (f-join langsup-base-path "compile-commands-json"))


(defun c-c++-rmsbolt-this-or-off ()
  (interactive)
  (if rmsbolt-mode
      ;; then, turn-off
      (rmsbolt-mode -1)
    ;; else
    (progn
      (setq-local rmsbolt-command
                  (compile-commands-json/rmsbolt-command
                   (make-read-compile-commands-in-dir (my-c-c++-build-dir))
                   (buffer-file-name)))
      ;;
      (rmsbolt-mode)
      (rmsbolt-compile))))



;;; GNU Global
(use-package ggtags :ensure t :pin melpa)



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
  (let ((proj (projectile-project-root))
        (bld (s-concat (my-c-c++-build-dir)
                       "/compile_commands.json")))
    (message "proj-dir=%s / build-dir=%s" proj bld)
    (irony-cdb-json-add-compile-commands-path proj bld))
  ;; irony
  (irony-mode +1)
  ;;
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
  ;; keys
  (c-c++-bind-key-map)
  ;; rmsbolt
  (setq-local rmsbolt-default-directory (my-c-c++-build-dir))
  )


(defun my-c-c++-mode-reset ()
  (interactive)
  (setq-local my-c-c++-touched nil)
  (my-c-c++-mode-hook))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the `major-mode' after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook)





(defun gtags-local-defs ()
  (message "Using GNU Global")
  (my-local-leader-def :keymaps 'c-mode-base-map
    "!" 'my-c-c++-mode-reset
    "b" 'c-c++-rmsbolt-this-or-off
    "f" 'flycheck-c/c++-setup
    ))


(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (ggtags-local-defs)))


;;; EOF
