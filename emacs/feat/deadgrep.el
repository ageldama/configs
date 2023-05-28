;;; deadgrep
(use-package deadgrep :ensure t :pin melpa
  :config (global-set-key (kbd "C-c k") 'deadgrep))
