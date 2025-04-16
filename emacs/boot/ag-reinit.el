(require 'seq)


(defvar ag-reinit-fns '())


(defun ag-reinit/add-fn (fn)
  (cl-pushnew fn ag-reinit-fns :test #'(lambda (x y) nil)))


(defmacro ag-reinit/add-as-interactive (&rest body)
  `(ag-reinit/add-fn (lambda () (interactive) ,@body)))


;; (ag-reinit/add-as-interactive (message "foo"))
;; (ag-reinit/add-as-interactive (message "bar"))
;; (ag-reinit/add-as-interactive (message "zoo"))
;;
;; (ag-reinit/run-all)

(defun ag-reinit/run-all ()
  "Run every added `fn`-s in reverse order of the
registration (`ag-reinit/add-fn`)"
  (interactive)
  (cl-loop for fn in (seq-reverse ag-reinit-fns)
           do (funcall fn)))




(provide 'ag-reinit)
