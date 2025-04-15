(require 'seq)
(require 'compile)



(defmacro defined-symbol-value (sym)
  "`sym'이 defined이면, 심볼평가한 값 (아니면 nil)"
  `(and (boundp ,sym)
        (symbol-value ,sym)))


(defmacro glob-first-file (&rest file-globs)
  "(다수의) `file-globs`에 매칭되는 첫번째만"
  `(seq-first (append
           ,@(mapcar (lambda (file-glob)
                       `(file-expand-wildcards ,file-glob))
                     file-globs))))


(defun buffer-path-and-line-col ()
  (interactive)
  (let ((pos (format "%s\t%s\t%s" (or (buffer-file-name) default-directory)
                     (line-number-at-pos) (current-column))))
    (kill-new pos)
    (message "Path (Yanked): %s" pos)))


(defun reload-emacs-rc ()
  (interactive)
  (load-file "~/.emacs"))


(defmacro def-compile-no-arg-cmd (name &rest body)
  (let ((cmd (gensym "cmd-"))
        (arg (gensym "arg-")))
    `(defun ,name (,arg)
       (interactive "P")
       (let ((,cmd ,@body))
         (unless (null ,arg)
           (setf ,cmd
                 (read-string "[git-cmd]: " ,cmd)))
         (compile ,cmd)))))




(provide 'ag-el)
