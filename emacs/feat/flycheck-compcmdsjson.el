(require 'flycheck-compcmdsjson)

(add-hook 'c-mode-common-hook #'flycheck-compcmdsjson/apply)

(dolist (i (list c-mode-map c++-mode-map))
  (define-key i (kbd "C-c ! C-f") 'flycheck-compcmdsjson/apply)
  (define-key i (kbd "C-c ! C-M-f") 'flycheck-compcmdsjson/forget))

