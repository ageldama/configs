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
(use-package rmsbolt :ensure t :pin melpa)

;;; ccls
(use-package ccls :ensure t :pin melpa
  :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda ()
                                                   (require 'ccls) (lsp))))


;;;
(defun ccls-local-defs ()
  (my-local-leader-def :keymaps 'c-mode-base-map
    "b" 'rmsbolt-mode
    ))


(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (ccls-local-defs)))

(add-hook 'c++-mode-hook #'c-c++-bind-key-map)
