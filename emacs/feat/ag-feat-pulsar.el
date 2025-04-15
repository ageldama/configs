(use-package pulsar :ensure t

  :bind
  (
   :map global-map
        ("C-c h p" . pulsar-pulse-line)
        ("C-c h h" . pulsar-highlight-line)
   )

  :config

  (setq
   pulsar-pulse t
   pulsar-delay 0.055
   pulsar-iterations 10
   pulsar-face 'pulsar-magenta
   pulsar-highlight-face 'pulsar-yellow
   )

  (dolist (hook '(org-mode-hook emacs-lisp-mode-hook))
    (add-hook hook #'pulsar-mode))

  (pulsar-global-mode +1))



(provide 'ag-feat-pulsar)
