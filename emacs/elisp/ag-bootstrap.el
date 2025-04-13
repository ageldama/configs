
(defmacro %ensure-package (pkg &rest args)
  `(use-package ,pkg :ensure t ,@args))

(%ensure-package seq)
(%ensure-package f)
(%ensure-package s)



(provide 'ag-bootstrap)
