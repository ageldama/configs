;;; rg / ripgrep

(use-package rg :ensure t
  :config (progn
            (global-set-key (kbd "M-s C-f") 'rg)
            (global-set-key (kbd "M-s g M-r") 'rg)

            (defun ag-rg/dwim+project ()
              (interactive)
              (rg-dwim (ag-project/cur-dir)))

            (ag-reinit/add-as-interactive
             (when (boundp 'evil-lookup-func)
               (setq evil-lookup-func #'ag-rg/dwim+project)))

            )
  )


(provide 'ag-feat-rg)
