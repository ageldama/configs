
;;; battery

(defun toggle-battery-saving-mode ()
  (interactive)
  (when (fboundp 'global-flycheck-mode)
    (call-interactively (function 'global-flycheck-mode -1)))
  (when (fboundp 'global-eldoc-mode)
    (call-interactively (function 'global-eldoc-mode    -1)))
  (when (fboundp 'global-company-mode)
    (call-interactively (function 'global-company-mode  -1)))
  ;;(global-hl-todo-mode)
  )


;;;
(provide 'ag-battery-saving-mode)
