;; go get golang.org/x/tools/gopls@latest
;; go get golang.org/x/tools/cmd/goimports

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
  ;;(add-hook 'before-save-hook #'lsp-format-buffer t t)
  ;;(add-hook 'before-save-hook #'lsp-organize-imports t t)
  ;;
  ;; NOTE: 2개으로 나눠 놓으면, async하게 동작하는 것 때문에 느린
  ;; 컴퓨터에서 파일을 깨먹어서, 하나의 gofmt만을 사용하고, 또, gofmt
  ;; 대신에 goimports을 써서 formatting, organize imports을 함께
  ;; 처리한다.
  (add-hook 'before-save-hook #'gofmt-before-save t t)
  )

(use-package go-mode :ensure t :pin melpa
  :config (progn (add-hook 'lsp-mode-hook 'lsp-ui-mode)
                 (add-hook 'go-mode-hook 'flycheck-mode)
                 (add-hook 'go-mode-hook 'lsp)
                 (add-hook 'before-save-hook 'lsp-go-install-save-hooks)
                 (setq lsp-prefer-flymake nil)))

(setq gofmt-command "goimports")

(use-package gotest :ensure t :pin melpa)


(setq lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)




(defhydra hydra-lang-go ()
  "go-lsp"
  
  ("r" go-run "run" :exit t)
  ("t" go-test-current-test "t-cur" :exit t)
  ("M-t f" go-test-current-file "t-curf" :exit t)
  ("M-t p" go-test-current-project "t-curp" :exit t)
  ("M-t v" go-test-current-coverage "t-cov" :exit t)
  ("M-t b" go-test-current-benchmark "t-cur-bench" :exit t)
  ("M-t F" go-test-current-file-benchmarks "t-curf-bench" :exit t)
  ("M-t B" go-test-current-project-benchmarks "t-curp-bench" :exit t)

  ("SPC" nil))

(lang-mode-hydra-set 'go-mode-hook 'hydra-lang-go/body)

