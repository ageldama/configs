;; NOTE: go get -u golang.org/x/tools/cmd/gopls

(use-package lsp-mode :ensure t :pin melpa
  :commands lsp
  :config
  (progn
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection "gopls")
                      :major-modes '(go-mode)
                      :server-id 'gopls))))

(use-package lsp-ui :commands lsp-ui-mode :ensure t :pin melpa)

(use-package company-lsp :commands company-lsp :ensure t :pin melpa
  :config (push 'company-lsp company-backends))

(use-package go-mode :ensure t :pin melpa
  :config (progn (add-hook 'lsp-mode-hook 'lsp-ui-mode)
                 (add-hook 'go-mode-hook 'flycheck-mode)
                 (add-hook 'go-mode-hook 'lsp)
                 (setq lsp-prefer-flymake nil)))

(use-package gotest :ensure t :pin melpa)

