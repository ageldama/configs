

(let ((proj-dir (cdr (project-current nil)))) ; nil = no-prompt
  (unless proj-dir
    (setf proj-dir (buffer-file-name)))
  (message "%s" proj-dir))



