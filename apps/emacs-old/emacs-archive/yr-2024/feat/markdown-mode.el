;;; markdown syntax highlighting and exporting
(use-package markdown-mode :ensure t :pin melpa
  :config (progn (setq markdown-command "pandoc")
                 (add-hook 'markdown-mode-hook
                           'turn-on-auto-fill)))
