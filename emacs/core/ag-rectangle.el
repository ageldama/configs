(defun my-insert-rectangle-push-lines ()
  "Yank a rectangle as if it was an ordinary kill."
  (interactive "*")
  (when (and (use-region-p) (delete-selection-mode))
    (delete-region (region-beginning) (region-end)))
  (save-restriction
    (narrow-to-region (point) (mark))
    (yank-rectangle)))


(global-set-key (kbd "C-x r C-y") #'my-insert-rectangle-push-lines)


(provide 'ag-rectangle)
