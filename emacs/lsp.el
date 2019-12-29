

(use-package lsp-mode :ensure t :pin melpa
  :defer t
  :commands lsp
  :custom
  (lsp-auto-guess-root nil)
  (lsp-prefer-flymake nil) ; Use flycheck instead of flymake
  (lsp-file-watch-threshold 2000)
  ;;:bind (:map lsp-mode-map ("C-c C-f" . lsp-format-buffer))
  :hook ((
          java-mode
          ;;python-mode go-mode
          ;;         js-mode js2-mode typescript-mode web-mode
          ;;         c-mode c++-mode objc-mode
          ) . lsp)
  )



(use-package lsp-ui :ensure t :pin melpa
  :after lsp-mode
  :diminish
  :commands lsp-ui-mode
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
  (lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic)))))
  :bind (:map lsp-ui-mode-map
              ;; `M-.' and `M-?'
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references)
              ("C-c u" . lsp-ui-imenu)
              ;;("C-c s"   . lsp-ui-sideline-mode)
              ("C-c a" . lsp-ui-sideline-apply-code-actions)
              )
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top
                       ;;'at-point
                       )
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-symbol t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-code-actions-prefix "* ")
  :config
  ;; Use lsp-ui-doc-webkit only in GUI
  (if +sys/gui?+
      (setq lsp-ui-doc-use-webkit t))
  ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
  ;; https://github.com/emacs-lsp/lsp-ui/issues/243
  (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
    (setq mode-line-format nil)))



(use-package dap-mode :ensure t :pin melpa
  :diminish
  :bind
  (:map dap-mode-map
        (("<f12>" . dap-debug)
         ("<f8>" . dap-continue)
         ("<f9>" . dap-next)
         ("<M-f11>" . dap-step-in)
         ("C-M-<f11>" . dap-step-out)
         ("<f7>" . dap-breakpoint-toggle)))
  :config
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  :hook ((after-init . dap-mode)
         (dap-mode . dap-ui-mode)
         ;;
         ;; (python-mode . (lambda () (require 'dap-python)))
         ;; (ruby-mode . (lambda () (require 'dap-ruby)))
         ;; (go-mode . (lambda () (require 'dap-go)))
         (java-mode . (lambda () (require 'dap-java)))
         ;; ((c-mode c++-mode objc-mode swift) . (lambda () (require 'dap-lldb)))
         ;; (php-mode . (lambda () (require 'dap-php)))
         ;; (elixir-mode . (lambda () (require 'dap-elixir)))
         ;; ((js-mode js2-mode typescript-mode) . (lambda () (require 'dap-chrome)))
         ))




(unless t
(use-package lsp-java :ensure t :pin melpa
  :after lsp-mode
  ;:if *mvn*
  :config
  (use-package request :defer t)
  :custom
  (lsp-java-server-install-dir (expand-file-name "~/.emacs.d/eclipse.jdt.ls/server/"))
  (lsp-java-workspace-dir (expand-file-name "~/.emacs.d/eclipse.jdt.ls/workspace/")))
)




;; DONE python + virtualenv



(unless t
;;(flycheck-add-next-checker 'python-flake8 'python-pylint)
;;(flycheck-add-next-checker 'python-flake8 'python-pycompile)
;;(flycheck-add-next-checker 'python-pycompile 'python-mypy)


(add-hook 'lsp-mode-hook (lambda ()
                                 (when (derived-mode-p 'python-mode)
                                   (message "python-mode flycheck checkers")
                                   (flycheck-disable-checker 'lsp-ui)
                                   (flycheck-select-checker 'python-flake8)
                                   )))



(use-package lsp-python-ms
  :ensure t :pin melpa
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))



(use-package direnv :ensure t :pin melpa
 :config
 (direnv-mode))
)



;; TODO golang
;; TODO C/C++ + (ccls -or- clangd)?
;; TODO Rust + (RLS -or- RustAnalyzer)?

