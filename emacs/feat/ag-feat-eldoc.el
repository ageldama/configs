
;;; eldoc
(use-package eldoc :ensure t :diminish eldoc-mode
  :config (add-hook 'prog-mode-hook 'eldoc-mode))


(provide 'ag-feat-eldoc)
