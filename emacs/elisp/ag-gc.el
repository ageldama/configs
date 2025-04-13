;;; Don't forget `M-x esup', profile your `.emacs'.
;; (setq gc-cons-threshold
;;       (if (< (or (car (memory-info)) 9999999999999999)
;;              (* 1024 1024 8))
;;           (* 1024 1024 500) ; 500 MiB
;;         ;; or, 100 MiB
;;         (* 1024 1024)))

(defvar *my-gc-timer* nil)

(defun my-gc-start-timer ()
  (interactive)
  (when (null *my-gc-timer*)
    (setq *my-gc-timer*
          (run-with-idle-timer 60 t
                               (lambda ()
                                 (garbage-collect))))))

(defun my-gc-cancel-timer ()
  (interactive)
  (when *my-gc-timer*
    (cancel-timer *my-gc-timer*)
    (setq *my-gc-timer* nil)))

(defun my-gc-toggle-timer ()
  (interactive)
  (if *my-gc-timer*
      (progn (my-gc-cancel-timer)
             (message "GC timer: cancelled"))
    (progn (my-gc-start-timer)
           (message "GC timer: started -- %s" *my-gc-timer*))))

;;(my-gc-start-timer)

;;;
(provide 'ag-gc)
