(require 'flycheck-compcmdsjson)
(require 'cc-mode)

(add-hook 'c-mode-common-hook #'flycheck-compcmdsjson/apply)

(define-key c-mode-base-map (kbd "C-c ! C-f") 'flycheck-compcmdsjson/apply)
(define-key c-mode-base-map (kbd "C-c ! C-M-f") 'flycheck-compcmdsjson/forget)
