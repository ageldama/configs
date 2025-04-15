

(use-package consult
  :ensure t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  ( :map global-map
    ;; ("M-g M-g" . consult-goto-line)
    ("M-K" . consult-keep-lines) ; M-S-k is similar to M-S-5 (M-%)
    ("M-F" . consult-focus-lines) ; same principle
    ("M-s M-b" . consult-buffer)
    ("M-s M-f" . consult-find)
    ("M-s M-g" . consult-grep)
    ("M-s M-h" . consult-history)
    ("M-s M-i" . consult-imenu)
    ("M-s M-l" . consult-line)
    ("M-s M-m" . consult-mark)
    ("M-s M-y" . consult-yank-pop)
    ("M-s M-s" . consult-outline)
    :map consult-narrow-map
    ("?" . consult-narrow-help))
  :config
  (setq consult-line-numbers-widen t)
  ;; (setq completion-in-region-function #'consult-completion-in-region)
  (setq consult-async-min-input 3)
  (setq consult-async-input-debounce 0.5)
  (setq consult-async-input-throttle 0.8)
  (setq consult-narrow-key nil)
  (setq consult-find-args
        (concat "find . -not ( "
                "-path */.git* -prune "
                "-or -path */.cache* -prune )"))
  (setq consult-preview-key 'any)
  (setq consult-project-function nil) ; always work from the current directory (use `cd' to switch directory)

  (add-to-list 'consult-mode-histories '(vc-git-log-edit-mode . log-edit-comment-ring))

  (require 'consult-imenu) ; the `imenu' extension is in its own file


  (with-eval-after-load 'pulsar
    ;; see my `pulsar' package: <https://protesilaos.com/emacs/pulsar>
    (setq consult-after-jump-hook nil) ; reset it to avoid conflicts with my function
    (dolist (fn '(pulsar-recenter-top pulsar-reveal-entry))
      (add-hook 'consult-after-jump-hook fn)))

  )


(provide 'ag-feat-consult)
