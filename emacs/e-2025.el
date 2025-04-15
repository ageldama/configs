;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; setup self

(require 'compat)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (file-name-parent-directory load-file-name))

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (concat %myself-dir rel-path) load-path
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

(%add-load-path-under-myself "elisp")
(%add-load-path-under-myself "feat")
(%add-load-path-under-myself "3rdparty")

;;; commons

(require 'benchmark)

(defun ag-requires (&rest require-syms)
  (interactive)
  (let ((len-require-syms (length require-syms))
        (idx 0)
        (requires-tag :*)
        (compile? nil))
    (cl-loop for require-sym in require-syms
             do (progn (cl-incf idx)
                       (cond ((keywordp require-sym)
                              (message "%s KW [%s/%s]: %s"
                                       requires-tag idx len-require-syms require-sym)
                              (cond ((string-prefix-p ":tag-" (symbol-name require-sym))
                                     (setf requires-tag
                                           (substring (symbol-name require-sym) (length ":tag-"))))
                                    ((eql :compile require-sym)
                                     (setf compile? t))
                                    ((eql :nocompile require-sym)
                                     (setf compile? nil))))
                             ;;
                             ((symbolp require-sym)
                              (progn (message "%s Requiring (%s) [%s/%s]:\t%s"
                                              requires-tag (if compile? "-COMP-" "-NOBC-")
                                              idx len-require-syms require-sym)
                                     (message "%s [%s/%s]\tElapsed: %s"
                                              requires-tag idx len-require-syms
                                              (benchmark-elapse
                                                (if compile?
                                                    (%ag-lib-do-compile-maybe require-sym)
                                                  (require require-sym)))))))))))

(ag-requires :tag-:*bootstrap
             :nocompile
             'ag-package
             'ag-bootstrap
             'ag-reinit
             'ag-el
             'ag-emacs-sensible
             'ag-hippie-expand
             'ag-font
             'ag-gc
             'ag-battery-saving-mode

             'ag-org
             'ag-writeroom-mode

             'ag-dired
             'ag-hydra
             'ag-which-key
             'ag-ibuffer

             'ag-diary

             'ag-wgrep
             'ag-mini-git
             'ag-compile

             'ag-lang-mode

             'ag-hydra--main
             'ag-global-keys
             )

(def-hydras)


;;;
(provide 'e-2025)

;;; EOF.
