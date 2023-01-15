
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


(defun diary/split-date (dt-str)
  (mapcar #'string-to-number (split-string dt-str "-")))

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


(defvar diary/make-diary-file-name/base-dir "~/P/v3/diary")

(defun diary/make-diary-file-name (yyyy-mm-dd-str)
  (let ((yyyy-mm-dd (diary/split-date yyyy-mm-dd-str)))
    (let* ((dt-fmt-str (apply #'diary/fmt-diary-date yyyy-mm-dd))
           (mon-fmt-str (diary/fmt-month dt-fmt-str)))
      (format "%s/%s/%s.org"
              diary/make-diary-file-name/base-dir
              mon-fmt-str dt-fmt-str))))

(defvar diary/initial-diary-content/tags '())

(defvar diary/initial-diary-content/fmt-title "%s")

(defun diary/initial-diary-content (&rest kws)
  "`KWS' := (:yyyy-mm-dd \"2023-01-23\" :file-name \"..\" ...)"
  (format (concat "#+TITLE: " diary/initial-diary-content/fmt-title
                  "\n#+TAGS[]: %s\n\n")
          (plist-get kws :yyyy-mm-dd)
          (string-join
           (mapcar (lambda (v) (format "%s" v))
                   diary/initial-diary-content/tags) " ")))


(defvar diary/fn-make-file-name #'diary/make-diary-file-name)

(defvar diary/fn-initial-content #'diary/initial-diary-content)


(defun diary/new-or-open-org-file ()
  (interactive)
  (let* ((yyyy-mm-dd (org-read-date))
         (file-name (funcall diary/fn-make-file-name yyyy-mm-dd)))
    (if (f-exists? file-name)
        (progn (message "FOUND: %s" file-name)
               (find-file file-name))
      ;; else
      (progn
        (message "NOT-FOUND: %S" file-name)
        (find-file file-name)
        ;; TITLE, TAGS
        (insert (funcall diary/fn-initial-content
                         :yyyy-mm-dd yyyy-mm-dd :file-name file-name))))))


(defvar diary/memo-types
  '(
    :memo
    (:fmt-title "MEMO: %s" :tags (memo daily) :base-dir "~/P/v3/memo")
    :tmp
    (:fmt-title "TMP: %s" :tags (memo tmp) :base-dir "/tmp")
    ))

(defun diary/memo-types/default ()
  (car diary/memo-types))

(defun diary/memo-types/select ()
  (let ((memo-types (cl-loop with idx = 0
                             for item in diary/memo-types
                             when (evenp idx)
                             collect item
                             do (cl-incf idx))))
    (intern
     (completing-read "Select memo type> " memo-types
                      nil ; predicate
                      nil ; require-match
                      nil ; initial-input
                      ))))


(defun diary/new-or-open-memo (&optional ask-memo-type?)
  (interactive "P")
  (let* ((memo-type-key (if ask-memo-type?
                            (diary/memo-types/select)
                          ;;else
                          (diary/memo-types/default)))
         (sel (plist-get diary/memo-types memo-type-key)))
    (let ((diary/initial-diary-content/fmt-title
           (plist-get sel :fmt-title))
          (diary/initial-diary-content/tags
           (plist-get sel :tags))
          (diary/make-diary-file-name/base-dir
           (plist-get sel :base-dir)))
      (diary/new-or-open-org-file))))


;;;EOF.
