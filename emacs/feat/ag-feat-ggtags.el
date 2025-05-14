
(use-package ggtags :ensure t :pin melpa
  :config (add-hook 'c-mode-hook
                    (lambda ()
                      (ggtags-mode +1))))

;;;
(provide 'ag-feat-ggtags)
