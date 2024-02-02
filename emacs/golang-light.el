(use-package go-mode :ensure t :pin melpa)

(use-package gotest :ensure t :pin melpa)

(when (and (fboundp 'go-mode) (memq window-system '(mac ns)))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-copy-env "GOROOT")
  (exec-path-from-shell-copy-env "GOPATH"))


(defhydra hydra-lang-go-light ()
  "go-light"

  ("r" go-run "run" :exit t)
  ("t" go-test-current-test "t-curT" :exit t)
  ("T" go-test-current-file "t-curF" :exit t)
  
  ("f"   gofmt "fmt" :exit t)

  ("d"   godoc "doc" :exit t)
  ("M-d" godoc-at-point "doc-pt" :exit t)

  ("D"   godef-describe "desc" :exit t)
  ("+"   go-import-add "imp+" :exit t)
  ("."   godef-jump "jmp" :exit t)

  ("SPC" nil))

;; "g"   'go-goto-map
;; "u"   'go-guru-map


(lang-mode-hydra-set 'go-mode-hook 'hydra-lang-go-light/body)

