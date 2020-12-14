;; NOTE: go get -u golang.org/x/tools/cmd/gopls

(use-package lsp-mode :ensure t :pin melpa
  :commands (lsp lsp-deferred)
  :config
  (progn
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection "gopls")
                      :major-modes '(go-mode)
                      :server-id 'gopls))))

(use-package lsp-ui :commands lsp-ui-mode :init
  :ensure t :pin melpa)

(use-package company-lsp :commands company-lsp
  :ensure t :pin melpa
  :config (push 'company-lsp company-backends))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package go-mode :ensure t :pin melpa
  :config (progn (add-hook 'lsp-mode-hook 'lsp-ui-mode)
                 (add-hook 'go-mode-hook 'flycheck-mode)
                 (add-hook 'go-mode-hook 'lsp)
                 (add-hook 'before-save-hook 'lsp-go-install-save-hooks)
                 (setq lsp-prefer-flymake nil)))


(use-package gotest :ensure t :pin melpa)


(setq lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)





(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "r" 'go-run
   "t" 'go-test-current-test
   "M-t f" 'go-test-current-file
   "M-t p" 'go-test-current-project
   "M-t v" 'go-test-current-coverage
   "M-t b" 'go-test-current-benchmark
   "M-t F" 'go-test-current-file-benchmarks
   "M-t B" 'go-test-current-project-benchmarks
   ))
