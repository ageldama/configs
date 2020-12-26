(use-package lsp-mode :ensure t :pin melpa
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode :init
  :ensure t :pin melpa)

(use-package company-lsp :commands company-lsp
  :ensure t :pin melpa
  :config (push 'company-lsp company-backends))

(setq lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)



(use-package lsp-java :ensure t :pin melpa
  :hook ((java-mode) . (lambda ()
                         (require 'lsp-java)
                         (lsp))))
