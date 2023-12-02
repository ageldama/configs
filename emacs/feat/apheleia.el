;; auto-format different source code files extremely intelligently
;; https://github.com/radian-software/apheleia
(use-package apheleia
  :ensure t
  ;; :config
  ;; (apheleia-global-mode +1)
  )

(add-hook 'prog-mode-hook 'apheleia-mode)

(global-set-key (kbd "C-c M-f") #'apheleia-format-buffer)



;;; EOF.
