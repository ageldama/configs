
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

(use-package flycheck-gometalinter
  :ensure t
  :config
  (progn
    (flycheck-gometalinter-setup)))

(use-package godoctor :ensure t :pin melpa)

(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "r" 'go-run
   "t" 'go-test-current-test
   "T" 'go-test-current-test
   "f" 'gofmt
   "d" 'godoc-at-point
   "D" 'godef-describe
   "+" 'go-import-add
   ">" 'godef-jump
   "g" 'go-goto-map
   "u" 'go-guru-map
   "R" '(:ignore t :which-key "godoctor")
   "R d" 'godoctor-godoc
   "R D" 'godoctor-godoc-dry-run
   "R r" 'godoctor-rename
   "R R" 'godoctor-rename-dry-run
   "R e" 'godoctor-extract
   "R E" 'godoctor-extract-dry-run
   "R t" 'godoctor-toggle
   "R T" 'godoctor-toggle-dry-run
   ))


;; golang.org/x/tools/...
;; github.com/rogpeppe/godef
;; github.com/golang/lint/golint
;; github.com/alecthomas/gometalinter
;; github.com/mdempsky/gocode
;; github.com/godoctor/godoctor


;;; EOF.
