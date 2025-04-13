


(defmacro defined-symbol-value (sym)
  "`sym'이 defined이면, 심볼평가한 값 (아니면 nil)"
  `(and (boundp ,sym)
        (symbol-value ,sym)))



(defun reload-emacs-rc ()
  (interactive)
  (load-file "~/.emacs"))




(provide 'ag-el)
