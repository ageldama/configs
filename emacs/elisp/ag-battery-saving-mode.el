
;;; battery

(defun toggle-battery-saving-mode ()
  (interactive)
  (when (fboundp #'global-flycheck-mode)
    (call-interactively #'global-flycheck-mode -1))
  (when (fboundp #'global-eldoc-mode)
    (call-interactively #'global-eldoc-mode    -1))
  (when (fboundp #'global-company-mode)
    (call-interactively #'global-company-mode  -1))
  ;;(global-hl-todo-mode)
  )


;;;
(provide 'ag-battery-saving-mode)
