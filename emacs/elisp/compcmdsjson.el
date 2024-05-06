;; (use-package levenshtein :pin melpa :ensure t)

(require 'cl)
(require 'f)
(require 'json)
(require 'levenshtein)
(require 'project)


;;; Code:


(defvar-local compcmdsjson/*path* nil)


(defvar-local compcmdsjson/*entry* nil)


(defvar compcmdsjson/*hooks* nil)



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
    (let* ((dir-dist (lambda (fn)
                       (cons fn (levenshtein-distance
                                 default-directory (f-dirname fn)))))
           (cdr-< (lambda (a b) (< (cdr a) (cdr b))))
           (sorted (sort (mapcar dir-dist files) cdr-<)))
      sorted)))


(defun compcmdsjson/select-found ()
  (interactive)
  (let ((files (mapcar #'car (compcmdsjson/find+dist))))
    (let ((selected
           (if (eq 1 (length files))
               (first files)
             ;; else
             (completing-read "Select: " files))))
      (when selected
        (setq-local compcmdsjson/*path* selected)
        (message "%s" compcmdsjson/*path*)
        ;; (compcmdsjson/find-entry)
        ))))


(defun compcmdsjson/select-nearest ()
  (let ((selected
         (first (mapcar #'car (compcmdsjson/find+dist)))))
    (when selected
      (setq-local compcmdsjson/*path* selected)
      ;; (compcmdsjson/find-entry)
      )))


(defun compcmdsjson/find-entry ()
  (setq-local compcmdsjson/*entry*
              (let ((fn (buffer-file-name))
                    (json-parsed (json-read-file compcmdsjson/*path*)))
                (cl-loop for i across json-parsed
                         ;; do (pp (alist-get 'file i))
                         if (string-equal (alist-get 'file i) fn)
                         return i)))
  (when compcmdsjson/*entry*
    (dolist (h compcmdsjson/*hooks*)
      (funcall h))))


(provide 'compcmdsjson)
