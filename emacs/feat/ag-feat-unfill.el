

;;; inverse of `fill-text'
(use-package unfill :ensure t :pin melpa
  :config
  (global-set-key (kbd "M-Q") 'unfill-region))


(provide 'ag-feat-unfill)
