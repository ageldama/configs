(require 'f)
(require 'levenshtein)

;;; Code:


(defvar-local compcmdsjson/*path* nil)


(defun compcmdsjson/find+dist ()
  "Find applicable `compile_commands.json'-files.
Within current project-root or directory of current buffer.  Sort
by nearest levenshtein distance from current buffer first.

Result looks like `(list (FULL-PATH . DISTANCE) ...)'."
  (let ((files (directory-files-recursively
                (project-root (project-current))
                "compile_commands\.json"
                t ;; include-dirs
                nil ;; predicate
                t ;; follow-symlink
                )))
    (let* ((dir-dist (lambda (fn) (cons fn (levenshtein-distance
                                            default-directory (f-dirname fn)))))
           (cdr-< (lambda (a b) (< (cdr a) (cdr b))))
           (sorted (sort (mapcar dir-dist files) cdr-<)))
      sorted)))


(defun compcmdsjson/read-found ()
  (interactive)
  (let ((selected (completing-read "Select: "
                                   (mapcar #'car (compcmdsjson/find+dist)))))
    (when selected
      (setq-local compcmdsjson/*path* selected)
      selected)))


(defun compcmdsjson/find-entry ()
  (json-parse-buffer
   
;;; TODO find-entry

;;; TODO find-entry-interactive

;;; TODO entry-found-hook


 
(provide 'compcmdsjson)
