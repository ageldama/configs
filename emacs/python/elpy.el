
(require 'direnv)

(use-package elpy :ensure t :pin melpa
  :config (add-hook 'python-mode-hook
                    (lambda ()
                      (message "venv=%s" (getenv "VIRTUAL_ENV"))
                      (when (getenv "VIRTUAL_ENV")
                        ;;(message "venv=%s" (getenv "VIRTUAL_ENV"))
                        (pyvenv-activate (getenv "VIRTUAL_ENV")))
                      (elpy-enable)))
  ;;
  (when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)))
