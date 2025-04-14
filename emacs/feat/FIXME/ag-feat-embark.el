
(when nil
  (use-package marginalia
    :ensure t
    :config
    (marginalia-mode)))

(use-package embark
  :ensure t

  :bind
  (
   ("<backtab>" . embark-act)         ;; pick some comfortable binding
   ("<f7>" . embark-act)         ;; pick some comfortable binding
   ("C-<f7>" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; (define-key org-mode-map (kbd "C-<tab>") #'embark-act)

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))


(when nil
  (use-package embark-consult
    :ensure t
    :after (embark consult)
    :demand t ; only necessary if you have the hook below
    ;; if you want to have consult previews as you move around an
    ;; auto-updating embark collect buffer
    :hook
    (embark-collect-mode . consult-preview-at-point-mode)))


(provide 'ag-feat-embark)
