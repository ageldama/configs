(defun ag-misc/insert-time-stamp ()
  (interactive)
  (insert (format-time-string "[%Y-%m-%d %a %H:%M]")))


;;;
(provide 'ag-misc)
