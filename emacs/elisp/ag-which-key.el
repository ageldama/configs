(use-package which-key :ensure t
  :diminish which-key-mode
  :config (progn (which-key-mode)
                 (which-key-setup-side-window-bottom)
                 (setq which-key-max-description-length 200)))

;;;
(provide 'ag-which-key)
