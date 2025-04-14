
;;; markdown syntax highlighting and exporting

(use-package markdown-mode :ensure t :pin melpa
  :config
  (setq markdown-command "pandoc")
  (add-hook 'markdown-mode-hook 'turn-on-auto-fill))


(provide 'ag-feat-markdown-mode)
