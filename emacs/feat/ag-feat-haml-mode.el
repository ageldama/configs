
(use-package haml-mode :ensure t
  :config
  (add-hook 'haml-mode-hook (lambda ()
                              (setq tab-width 2)
                              (setq indent-tabs-mode nil))))



(provide 'ag-feat-haml-mode)
