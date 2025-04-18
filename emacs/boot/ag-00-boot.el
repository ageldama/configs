
;;; setup self

(require 'compat)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (file-name-parent-directory load-file-name))

(defvar %ag-myself-dir %myself-dir)

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (expand-file-name (concat %myself-dir rel-path)) load-path
              :test #'equal))


(defun %ag-lib-elc-file-name (lib)
  (if-let (el-or-elc-fn (locate-library (symbol-name lib)))
      `(,(file-name-with-extension el-or-elc-fn "el") . ,(file-name-with-extension el-or-elc-fn "elc"))
    ;; not-found:
    (error "locate-library fail: %s" lib)))



(defun %ag-lib-need-to-compile? (lib)
  (pcase-let ((`(,el-fn . ,elc-fn) (%ag-lib-elc-file-name lib)))
    `(:el ,el-fn :elc ,elc-fn
          :need-to-compile?
          ,(not (and (file-exists-p elc-fn)
                     (file-newer-than-file-p elc-fn el-fn))))))


(defun %ag-lib-do-compile-maybe (lib &optional no-error?)
  (condition-case err
      ;; body
      (pcase-let ((`(:el ,el-fn :elc ,elc-fn :need-to-compile? ,need-to?)
                   (%ag-lib-need-to-compile? lib)))
        (progn
          (message ";;; el %s // elc %s // need-to-compile? %s"
                   el-fn elc-fn need-to?)
          (when need-to?
            (byte-compile-file el-fn))))
    ;; err => handler
    (error (if no-error?
               (message ";;; IGN-ERR -- %s" err)
             (signal (car err) (cdr err))))))


;;; load-paths

(%add-load-path-under-myself "../core")
(%add-load-path-under-myself "../feat")
(%add-load-path-under-myself "../3rdparty")
(%add-load-path-under-myself "../elisp") ; empty, but kept.


;;; requires

(require 'benchmark)

(defun ag-requires (&rest require-syms)
  (interactive)
  (let ((len-require-syms (length require-syms))
        (idx 0)
        (requires-tag :*)
        (compile? nil))
    (cl-labels ((log-req (require-sym msg)
                  (message "%s REQ %s (%s) [%s/%s]:\t%s"
                           requires-tag require-sym
                           (if compile? "-COMP-" "-NOBC-")
                           idx len-require-syms msg))
                (log-kw (require-sym)
                  (message "%s KW [%s/%s]: %s"
                           requires-tag idx len-require-syms require-sym))
                (@-kw (require-sym)
                  (log-kw require-sym)
                  (cond ((string-prefix-p ":tag-" (symbol-name require-sym))
                         (setf requires-tag
                               (substring (symbol-name require-sym) (length ":tag-"))))
                        ((eql :compile require-sym)
                         (setf compile? t))
                        ((eql :nocompile require-sym)
                         (setf compile? nil))))
                (@-sym (require-sym)
                  (log-req require-sym "... requiring")
                  (log-req require-sym
                           (format "elapsed %s"
                                   (benchmark-elapse
                                     (if compile?
                                         (%ag-lib-do-compile-maybe require-sym)
                                       (require require-sym)))))))
    (cl-loop for require-sym in require-syms
             do (progn (cl-incf idx)
                       (cond ((keywordp require-sym) (@-kw require-sym))
                             ((symbolp require-sym) (@-sym require-sym))))))))



;;;
(provide 'ag-00-boot)
