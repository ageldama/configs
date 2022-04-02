(use-package go-mode :ensure t :pin melpa
  :config (add-hook 'go-mode-hook (lambda ()
                                    (setq company-idle-delay 1.0)
                                    (add-hook 'before-save-hook 'gofmt-before-save))))

(when (and (fboundp 'go-mode) (memq window-system '(mac ns)))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-copy-env "GOROOT")
  (exec-path-from-shell-copy-env "GOPATH"))


(when (fboundp 'general-create-definer)
  (my-local-leader-def
   :keymaps 'go-mode-map
   "f"   'gofmt
   "d"   'godoc
   "M-d" 'godoc-at-point
   "D"   'godef-describe
   "+"   'go-import-add
   "."   'godef-jump
   ;; "g"   'go-goto-map
   ;; "u"   'go-guru-map
   ))

