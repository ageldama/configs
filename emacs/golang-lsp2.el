(use-package go-mode :ensure t)


(use-package lsp-mode :ensure t)
(use-package lsp-ui :ensure t)

(use-package eglot :ensure t)

(add-hook 'eglot--managed-mode-hook
          #'lsp-lens-mode)

(define-key eglot-mode-map (kbd "C-c e p") #'flymake-goto-prev-error)
(define-key eglot-mode-map (kbd "C-c e n") #'flymake-goto-next-error)
(define-key eglot-mode-map (kbd "C-c e l") #'flymake-show-buffer-diagnostics)
(define-key eglot-mode-map (kbd "C-`") #'flymake-goto-next-error)


(define-key eglot-mode-map (kbd "C-c RET") #'eglot-code-actions)

(defhydra hydra-lang-golang ()
  "golang"

  ("M-p" flymake-goto-prev-error "prv-err")
  ("M-n" flymake-goto-next-error "nxt-err")
  ("L"   flymake-show-buffer-diagnostics "buf-errs")
  ("RET" eglot-code-actions "actions")

  ("SPC" nil))

(lang-mode-hydra-set 'go-mode-hook 'hydra-lang-golang/body)



