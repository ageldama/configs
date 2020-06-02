
(load-library (f-join langsup-base-path "compcmdsjson/compcmdsjson"))


(defun my-cc-build-dir () (getenv "BUILD_DIR"))



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


(defun c-c++-rmsbolt-this-or-off ()
  (interactive)
  (if rmsbolt-mode
      ;; then, turn-off
      (rmsbolt-mode -1)
    ;; else
    (progn
      (setq-local rmsbolt-command
                  (compcmdsjson-get-compcmds-rmsbolt
                   (s-concat (my-cc-build-dir) "/compile_commands.json")
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
  (let ((inc-dirs (compcmdsjson-get-incdirs
                   (s-concat (my-cc-build-dir) "/compile_commands.json")
                   (buffer-file-name))))
    (message "Include-Dirs: %S" inc-dirs)
    (setq-local flycheck-clang-include-path inc-dirs)
    (setq-local flycheck-gcc-include-path inc-dirs)
    (setq-local flycheck-clang-tidy-build-path
                (my-cc-build-dir)))
  ;;
  (setq-local my-c-c++-touched t)
  (ignore-errors
    (flycheck-buffer)))



;;;
(defun my-c-c++-ggtags-hook ()
  (ggtags-mode 1)
  (eldoc-mode 1)
  (company-mode 1))

  

(defun my-c-c++-mode-hook ()
  (interactive)
  (my-c-c++-ggtags-hook)
  (unless my-c-c++-touched
    (run-with-timer 0.5 nil #'flycheck-c/c++-setup))
  (flycheck-mode)
  ;; keys
  (c-c++-bind-key-map)
  ;; rmsbolt
  (setq-local rmsbolt-default-directory (my-cc-build-dir)))


(defun my-c-c++-mode-reset ()
  (interactive)
  (compcmdsjson-clear-incdirs-cache)
  (setq-local my-c-c++-touched nil)
  (my-c-c++-mode-hook))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the `major-mode' after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook)





(defun ggtags-local-defs ()
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
