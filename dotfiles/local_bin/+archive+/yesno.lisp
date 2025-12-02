(in-package #:cl-user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :uiop))


(defpackage #:yesno-rofi
  (:use #:cl))


(in-package #:yesno-rofi)


(defun main ()
  (handler-case
      (let* ((cmd (format nil "rofi -theme-str 'window {width: 200px; height: 150px;}' -dmenu -p '~a' -sep '\0' -eh 2 -markup-rows -format i"
                          "yes/no?"))
             (proc (uiop:launch-program cmd
                                        :output :stream
                                        :input :stream)))
        (flet ((write-to-proc (p s)
                 (format (uiop:process-info-input p) s)))
          (write-to-proc proc
                         "<span size='x-large' weight='heavy'>Yes</span>\0")
          (write-to-proc proc
                         "<span size='x-large' weight='heavy'>No</span>\0"))
        (force-output (uiop:process-info-input proc))
        ;;
        (let ((exit-code (uiop:wait-process proc))
              (stdout-str (read-line (uiop:process-info-output proc))))
          (format t "STDOUT: ~a~%" stdout-str)
          (format t "EXIT: ~a~%" exit-code)))
    ;;
    (error (c) (format t "ERR: ~a~%" c))))




(in-package #:cl-user)

#+(and :sbcl :build-exe)
(sb-ext:save-lisp-and-die "yesno.sbcl"
                          :executable t
                          :toplevel #'yesno-rofi::main
                          ;; :compression t
                          :save-runtime-options t)

;; sbcl --eval "(push :build-exe cl:*features*)" --load yesno.lisp
