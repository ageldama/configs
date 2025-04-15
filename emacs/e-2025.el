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
          ,(not (and (f-exists? elc-fn)
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

(defun ag-requires (&rest require-syms)
  (interactive)
  (let ((compile? (member :compile-ifneeded? require-syms)))
    (cl-loop for require-sym in require-syms
             unless (keywordp require-sym)
             do (progn (when compile?
                         (%ag-lib-do-compile-maybe require-sym))
                       (require require-sym)))))

(ag-requires :compile-ifneeded?
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
             )

(def-hydras)

(ag-requires 'ag-global-keys)


;;;
(provide 'e-2025)

;;; EOF.
