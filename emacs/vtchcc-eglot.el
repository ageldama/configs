(use-package typescript-mode :ensure t)






;; auto-format different source code files extremely intelligently
;; https://github.com/radian-software/apheleia
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))


(use-package eglot :ensure t)

(add-hook 'eglot--managed-mode-hook
          #'lsp-lens-mode)

(define-key eglot-mode-map (kbd "C-c e p") #'flymake-goto-prev-error)
(define-key eglot-mode-map (kbd "C-c e n") #'flymake-goto-next-error)
(define-key eglot-mode-map (kbd "C-c e l") #'flymake-show-buffer-diagnostics)
(define-key eglot-mode-map (kbd "C-`") #'flymake-goto-next-error)

(define-key eglot-mode-map (kbd "C-c e f") #'apheleia-format-buffer)

(define-key eglot-mode-map (kbd "C-c RET") #'eglot-code-actions)

(defhydra hydra-lang-typescript ()
  "typescript"

  ("M-p" flymake-goto-prev-error "prv-err")
  ("M-n" flymake-goto-next-error "nxt-err")
  ("L"   flymake-show-buffer-diagnostics "buf-errs")
  ("f"   apheleia-format-buffer "fmt")
  ("RET" eglot-code-actions "actions")

  ("SPC" nil))

(lang-mode-hydra-set 'typescript-mode-hook 'hydra-lang-typescript/body)
   


(use-package yaml-mode :ensure t :pin melpa)
