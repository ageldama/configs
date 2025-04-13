
;;; ibuffer
(if (fboundp 'helm-buffers-list)
    (progn (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
           (global-set-key (kbd "C-x B") 'ibuffer))
  (global-set-key (kbd "C-x C-b") 'ibuffer))


;;;
(provide 'ag-ibuffer)
