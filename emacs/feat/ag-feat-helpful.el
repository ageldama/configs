
;;; helpful, discover-my-major
(use-package helpful :pin melpa :ensure t
  :config (progn
            (setq counsel-describe-function-function #'helpful-callable)
            (setq counsel-describe-variable-function #'helpful-variable)
            (global-set-key (kbd "C-h f") #'helpful-callable)
            (global-set-key (kbd "C-h v") #'helpful-variable)
            (global-set-key (kbd "C-h k") #'helpful-key)
            (global-set-key (kbd "C-h C-.") #'helpful-at-point)))




(provide 'ag-feat-helpful)
