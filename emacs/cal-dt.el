
(defun diary/fmt-diary-date (year month day)
  (let ((date-time-str
         (string-join (list (format "%04d-%02d-%02d" year month day)
                            "T12:21:54+0000"))))
    (format-time-string "%Y-%m%b-%d%a" 
                        (date-to-time date-time-str))))

;; (diary/fmt-diary-date 1982 10 13)

;; (diary/fmt-diary-date 2021 5 13)

(defun diary/fmt-month (fmt-str)
  (let ((dts (split-string fmt-str "-")))
    (s-concat (nth 0 dts) "-" (nth 1 dts))))


(defun diary/sel-date (dt-str)
  (let* ((dt-str2 (split-string dt-str "-"))
         (dt (mapcar #'string-to-number dt-str2)))
    dt))

;; (diary/sel-date (org-read-date))


(defvar diary/wrong-name-rx
    (rx (group (= 4 digit)) "-"
        (group (= 2 digit)) "-"
        (group (= 2 digit)) ".org"))


(defun diary/list-wrong-fmt-files ()
  (interactive)
  (--filter 
   (string-match diary/wrong-name-rx it)
   (directory-files ".")))

(defun diary/fix-name (name)
  (let* ((extracts (car (s-match-strings-all diary/wrong-name-rx name)))
         (name-fmt (apply #'diary/fmt-diary-date
                          (mapcar #'string-to-number (cdr extracts))))
         (name-fmt* (s-concat name-fmt ".org")))
    name-fmt*))

;; (diary/fix-name "2020-09-02.org")

(defun diary/rename-date-fmt-files ()
  (interactive)
  (let ((wrong-names (diary/list-wrong-fmt-files)))
    (dolist (wrong-name wrong-names)
      (let ((new-name (diary/fix-name wrong-name)))
        (if (f-exists? new-name)
            (message "# EXISTS: mv %s %s" wrong-name new-name)
            ;; else
          (f-move wrong-name new-name))))))


(defun diary/new-or-open-org-file ()
  (interactive)
  (let* ((yyyy-mm-dd (diary/sel-date (org-read-date)))
         (dt-fmt-str (apply #'diary/fmt-diary-date yyyy-mm-dd))
         (mon-fmt-str (diary/fmt-month dt-fmt-str))
         (file-name (format "~/P/v3/diary/%s/%s.org"
                            mon-fmt-str dt-fmt-str)))
    (if (f-exists? file-name)
        (progn (message "FOUND: %s" file-name)
               (find-file file-name))
      ;; else
      (progn
        (message "NOT-FOUND: %S" file-name)
        (find-file file-name)
        ;; TITLE, TAGS
        (insert (format "#+TITLE: %s\n#+TAGS[]: \n\n" dt-fmt-str))))))

         
