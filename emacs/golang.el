;;;

(use-package go-mode :ensure t :pin melpa
  :config (add-hook 'go-mode-hook (lambda ()
                                    (setq company-idle-delay 1.0)
                                    (add-hook 'before-save-hook 'gofmt-before-save))))

(when (and (fboundp 'go-mode) (memq window-system '(mac ns)))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-copy-env "GOROOT")
  (exec-path-from-shell-copy-env "GOPATH"))

(use-package go-eldoc :ensure t :pin melpa
  ;; :config (add-hook 'go-mode-hook 'go-eldoc-setup)
  )

(use-package golint :ensure t :pin melpa)

(use-package go-projectile :ensure t :pin melpa)

;; (use-package flycheck-golangci-lint :ensure t :pin melpa
;;     :config (eval-after-load 'flycheck
;;               '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup)))

(use-package gotest :ensure t :pin melpa)

(use-package go-imports :ensure t :pin melpa)

(use-package go-dlv :ensure t :pin melpa)

(when nil
  (use-package company-go :ensure t :pin melpa
    :config (add-hook 'go-mode-hook
                      (lambda ()
                        (set (make-local-variable 'company-backends) '(company-go))
                        (company-mode)))))

(use-package flycheck-gometalinter
  :ensure t
  :config
  (progn
    ;; Only enable selected linters
    (setq flycheck-gometalinter-disable-all t)
    ;; (setq flycheck-gometalinter-enable-linters '("vet" "golint" "gofmt" "gosec" "misspell"
    ;;                                              ;;"vetshadow" ;;"varcheck" ;;"gotype"
    ;;                                              ))
    ;;
    (flycheck-gometalinter-setup)))

(use-package godoctor :ensure t :pin melpa)

(defhydra hydra-lang-go ()
  "go"
  
  ("r" go-run "run" :exit t)
  ("t" go-test-current-test "t-curt" :exit t)
  ("T" go-test-current-file "t-curf" :exit t)
  ("f" gofmt "fmt" :exit t)
  ("d" godoc "doc" :exit t)
  ("M-d" godoc-at-point "doc-pt" :exit t)
  ("D" godef-describe "desc" :exit t)
  ("+" go-import-add "imp+" :exit t)
  ("." godef-jump "def-jmp" :exit t)
  ("g" go-goto-map "goto" :exit t)
  ("u" go-guru-map "guru" :exit t)
  ("R d" godoctor-godoc "godoc" :exit t)
  ("R D" godoctor-godoc-dry-run "godoc-dry" :exit t)
  ("R r" godoctor-rename "ren" :exit t)
  ("R R" godoctor-rename-dry-run "ren-dry" :exit t)
  ("R e" godoctor-extract "extract" :exit t)
  ("R E" godoctor-extract-dry-run "extract-dry" :exit t)
  ("R t" godoctor-toggle "toggle" :exit t)
  ("R T" godoctor-toggle-dry-run "toggle-dry" :exit t)

  ("SPC" nil))

(lang-mode-hydra-set 'go-mode-hook 'hydra-lang-go/body)


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
