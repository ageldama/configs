(defvar input-method/*stack* '())

(defun input-method/save ()
  (interactive)
  (push current-input-method input-method/*stack*))

(defun input-method/save+reset ()
  (interactive)
  (input-method/save)
  (deactivate-input-method))

(defun input-method/restore ()
  (interactive)
  (let ((im (pop input-method/*stack*)))
    (if (null im) (deactivate-input-method)
      (activate-input-method im))))


(provide 'ag-input-method-stack)
