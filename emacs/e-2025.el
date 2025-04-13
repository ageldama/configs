;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; setup self

(require 'f)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (f-dirname load-file-name))

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (f-join %myself-dir rel-path) load-path
              :test #'equal))

(%add-load-path-under-myself "elisp")

;;; basics

(require 'ag-el)
(require 'ag-emacs-sensible)
(require 'ag-hippie-expand)
(require 'ag-font)
(require 'ag-package)



;;;
(provide 'e-2025)

;;; EOF.
