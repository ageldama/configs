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
                 (add-hook 'before-save-hook 'gofmt-before-save)
                 (setq lsp-prefer-flymake nil)))


(use-package gotest :ensure t :pin melpa)









(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "r" 'go-run
   "t" 'go-test-current-test
   "T f" 'go-test-current-file
   "T p" 'go-test-current-project
   "T v" 'go-test-current-coverage
   "T b" 'go-test-current-benchmark
   "T F" 'go-test-current-file-benchmarks
   "T B" 'go-test-current-project-benchmarks
   ))
