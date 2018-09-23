(defun cquery//enable ()
  (condition-case nil
      (lsp-cquery-enable)
    (user-error nil)))

(use-package cquery :ensure t :pin melpa
    :commands lsp-cquery-enable
    :init (add-hook 'c-mode-hook #'cquery//enable)
    (add-hook 'c++-mode-hook #'cquery//enable))

(use-package company-lsp :ensure t :pin melpa
  :config (progn
            (setq company-transformers nil
                  company-lsp-async t
                  company-lsp-cache-candidates nil)
            (push 'company-lsp company-backends)))

(use-package lsp-ui :ensure t :pin melpa
  :config  (progn
             (require 'lsp-ui-flycheck)
             (with-eval-after-load 'lsp-mode
               (add-hook 'lsp-after-open-hook
                         (lambda () (lsp-ui-flycheck-enable 1))))))

;; (with-eval-after-load 'projectile
;;   (setq projectile-project-root-files-top-down-recurring
;;         (append '("compile_commands.json"
;;                   ".cquery")
;;                 projectile-project-root-files-top-down-recurring)))

(use-package helm-xref :ensure t :pin melpa
  :config (setq xref-show-xrefs-function 'helm-xref-show-xrefs))

;;; EOF
