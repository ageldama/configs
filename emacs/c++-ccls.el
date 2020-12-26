(use-package lsp-mode :ensure t :pin melpa
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode :init
  :ensure t :pin melpa)

(use-package company-lsp :commands company-lsp
  :ensure t :pin melpa
  :config (push 'company-lsp company-backends))

(setq lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)






;;; Debugger, CMake, Modern-CPP

(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config
  (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))


;;; RMSBolt
;; FIXME: broken nao w/ ccls.
(unless t

(load-library (f-join langsup-base-path "compcmdsjson/compcmdsjson"))
(defun my-cc-build-dir () (getenv "BUILD_DIR"))

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
)

;;; ccls
(use-package ccls :ensure t :pin melpa
  :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda ()
                                                   (require 'ccls) (lsp))))


