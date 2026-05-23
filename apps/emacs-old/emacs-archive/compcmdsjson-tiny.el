
(require 'cl)
(require 'f)
(require 'project)


;;; Code:


(defun compcmdsjson-tiny/find-nearest ()
  (let ((top-dir (cdr (project-current)))
        (cur-dir default-directory)
        (fn nil))
    (cl-loop do (setf fn (f-join cur-dir "compile_commands.json"))
             (when (f-exists? fn)
               (cl-return fn))
             (when (f-equal? cur-dir top-dir)
               (cl-return nil))
             ;; otherwise
             (setf cur-dir (f-parent cur-dir))
             (when (null cur-dir)
               (cl-return nil))
             )))


(provide 'compcmdsjson-tiny)
