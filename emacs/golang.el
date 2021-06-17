;;;

(use-package go-mode :ensure t :pin melpa
  :config (add-hook 'go-mode-hook (lambda ()
                                    (setq company-idle-delay 0.2)
                                    (add-hook 'before-save-hook 'gofmt-before-save))))

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

(use-package go-imports :ensure t :pin melpa)

(use-package go-dlv :ensure t :pin melpa)

(use-package company-go :ensure t :pin melpa
  :config (add-hook 'go-mode-hook
                    (lambda ()
                      (set (make-local-variable 'company-backends) '(company-go))
                      (company-mode))))

(use-package flycheck-gometalinter
  :ensure t
  :config
  (progn
    ;; Only enable selected linters
    (setq flycheck-gometalinter-disable-all t)
    (setq flycheck-gometalinter-enable-linters '(
                                                 "vet"
                                                 ;;"vetshadow"
                                                 ;;"varcheck"
                                                 "golint" "gofmt" "gosec"
                                                 "misspell"
                                                 ;;"gotype"
                                                 ))
    ;;
    (flycheck-gometalinter-setup)))

(use-package godoctor :ensure t :pin melpa)

(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "r" 'go-run
   "t" 'go-test-current-test
   "T" 'go-test-current-file
   "f" 'gofmt
   "d" 'godoc-at-point
   "D" 'godef-describe
   "+" 'go-import-add
   "." 'godef-jump
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

(defun golang-fff ()
"
go get -u golang.org/x/tools/...
go get -u github.com/rogpeppe/godef
go get -u github.com/golang/lint/golint
go get -u github.com/stamblerre/gocode
go get -u github.com/godoctor/godoctor
go get -u golang.org/x/lint/golint
go get -u github.com/kisielk/errcheck
go get github.com/mdempsky/unconvert

https://staticcheck.io/docs/

#go get -u github.com/alecthomas/gometalinter
")



;;; EOF.
