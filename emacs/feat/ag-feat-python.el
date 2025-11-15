
(defun -complete--uv-or-python--pylsp-cmd ()
  (append
   (let ((uv-exe (executable-find "uv"))
         (python-exe (executable-find "python"))
         (python3-exe (executable-find "python3")))
     (cond
      ((not (null uv-exe)) '("uv" "run"))
      (t (list (or python-exe python3-exe) "-m"))))
   '("pylsp")))


(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               (cons 'python-mode (-complete--uv-or-python--pylsp-cmd))))


(provide 'ag-feat-python)
