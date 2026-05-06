

(require 'cl-lib)



(defvar recompile-buffer-modes
  '(compilation-mode grep-mode go-test-mode)
  "recompile 적용될 mode 이름

(add-to-list 'recompile-buffer-modes 'xxx-mode)")



(defun recompile%visible-window-list ()
  "window list of visible frames"
  (cl-loop for frame in (visible-frame-list)
           append (with-selected-frame frame
                     (cl-loop for window in (window-list)
                              collect (cons frame window)))))


(defun recompile-buffer-mode-p (frame window)
  "recompile 대상인 frame/window인가?

(`recompile-buffer-modes'에 포함되는 `major-mode')"
  (with-selected-frame frame
    (with-current-buffer (window-buffer window)
      (member major-mode recompile-buffer-modes))))


;; (recompile%visible-window-list)
;; (recompile%applicable-window-list)


(defun recompile%applicable-window-list ()
  "보이는 frame/window 중, `recompile-buffer-modes' 에 포함 되는
(frame . window)-list."
  (cl-loop for f.w in (recompile%visible-window-list)
           when (recompile-buffer-mode-p (car f.w) (cdr f.w))
           collect f.w))


(cl-defmacro recompile%with-frame.window
    ((var-frame var-window) frame.window
     &body body)
  `(cl-destructuring-bind (,var-frame . ,var-window) ,frame.window
     (with-selected-frame ,var-frame
       (with-current-buffer (window-buffer ,var-window)
         ,@body))))


(defun recompile%do-recompile (frame.window)
  (recompile%with-frame.window
   (f w) frame.window
   (recompile)))


(defun recompile%name-frame.window (frame.window)
  (recompile%with-frame.window
   (f w) frame.window
   (format "%s: %s"
           (frame-parameter nil 'name)
           (buffer-name))))





(defun recompile%select-and-recompile (frame.window-list)
  (let ((names (cl-loop with count = 0
                        for f.w in frame.window-list
                        do (cl-incf count)
                        collect (message "<%d> %s"
                                         count
                                         (recompile%name-frame.window f.w)))))
    (let* ((sel-name (completing-read "recompile on? " names))
           (sel-idx  (cl-position sel-name names :test #'equal))
           (sel-f.w  (elt frame.window-list sel-idx)))
      (recompile%do-recompile sel-f.w))))




(defun recompile-visible-compilation-window ()
  (interactive)
  (if (member major-mode recompile-buffer-modes)
      (recompile)
    ;; else:
    (let* ((frame.window-list (recompile%applicable-window-list)))
      (cl-case (length frame.window-list)
        (0 (progn (message "no comile-buffer found")
                  (call-interactively 'compile)))
        (1 (recompile%do-recompile
            (cl-first frame.window-list)))
        (t (recompile%select-and-recompile frame.window-list))))))






(provide 'ag-recompile)



