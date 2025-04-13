
;;; expand-region
(use-package expand-region :ensure t :pin melpa
  :config 
  (global-set-key (kbd "C-=") 'er/expand-region))


;;;
(provide 'ag-expand-region)
