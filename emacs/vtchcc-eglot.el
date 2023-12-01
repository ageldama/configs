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
