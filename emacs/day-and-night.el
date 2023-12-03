

(defvar *day-and-night/day-theme* 'modus-operandi-tinted)
(defvar *day-and-night/night-theme* 'modus-vivendi)

(defvar *day-and-night/day-starting-at* 600)
(defvar *day-and-night/night-starting-at* 1800)

(defvar *day-and-night/last-theme* nil)


(defun day-and-night/now ()
  (string-to-number (format-time-string "%H%M")))

(defun day-and-night/theme-by-time ()
  (let ((now (day-and-night/now)))
    (if (<= *day-and-night/day-starting-at*
            now
            *day-and-night/night-starting-at*)
        *day-and-night/day-theme*
      ;; else
      *day-and-night/night-theme*)))

(defun day-and-night/change-theme-by-time ()
  (interactive)
  (let ((theme (day-and-night/theme-by-time)))
    (unless (eq theme *day-and-night/last-theme*)
      (load-theme theme t nil)
      (message "Changing theme: %s" theme)
      (setf *day-and-night/last-theme* theme))))


(defvar *day-and-night/idle-timer* nil)

(defun day-and-night/start-timer (secs)
  (when (null *day-and-night/idle-timer*)
    (setf *day-and-night/idle-timer*
          (run-with-idle-timer
           secs 1 (lambda () (day-and-night/change-theme-by-time))))))

(defun day-and-night/cancel-timer ()
  (interactive)
  (unless (null *day-and-night/idle-timer*)
    (cancel-timer *day-and-night/idle-timer*)
    (setf *day-and-night/idle-timer* nil)))


(provide 'day-and-night)
