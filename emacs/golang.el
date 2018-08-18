
(use-package go-mode :ensure t :pin melpa)

(when (and (fboundp 'go-mode) (memq window-system '(mac ns)))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-copy-env "GOROOT")
  (exec-path-from-shell-copy-env "GOPATH"))

(use-package go-eldoc :ensure t :pin melpa
  :config (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package golint :ensure t :pin melpa)

(use-package go-projectile :ensure t :pin melpa)

(use-package flycheck-golangci-lint :ensure t :pin melpa
    :config (eval-after-load 'flycheck
              '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup)))

(use-package gotest :ensure t :pin melpa)

(use-package company-go :ensure t :pin melpa
  :config (add-hook 'go-mode-hook
                    (lambda ()
                      (set (make-local-variable 'company-backends) '(company-go))
                      (company-mode))))
;; gorun
;; go-test-current-file
;; go-test-current-test
;; gofmt
;; godoc
(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "r" 'go-run
   "t" 'go-test-current-test
   "T" 'go-test-current-test
   "f" 'gofmt
   "d" 'godoc
   ))

;;; EOF.
