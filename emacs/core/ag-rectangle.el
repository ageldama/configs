
(defun my-yank-rectangle-as-lines ()
  "Yank a rectangle as if it was an ordinary kill (as lines)."
  (interactive "*")
  (let ((rect (car kill-ring)))
    ;; Check if the last thing killed was a rectangle
    (if (string-match-p "\n" rect)
        (insert rect) ;; Insert normally if it's already multi-line
      (yank-rectangle))))


(global-set-key (kbd "C-x r M-y") #'my-yank-rectangle-as-lines)



(provide 'ag-rectangle)
