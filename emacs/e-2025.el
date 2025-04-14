;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; setup self

(require 'compat)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (file-name-parent-directory load-file-name))

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (concat %myself-dir rel-path) load-path
              :test #'equal))

(%add-load-path-under-myself "elisp")
(%add-load-path-under-myself "feat")
(%add-load-path-under-myself "3rdparty")

;;; commons

(require 'ag-package)
(require 'ag-bootstrap)
(require 'ag-reinit)
(require 'ag-el)
(require 'ag-emacs-sensible)
(require 'ag-hippie-expand)
(require 'ag-font)
(require 'ag-gc)
(require 'ag-battery-saving-mode)

(require 'ag-org)
(require 'ag-writeroom-mode)

(require 'ag-dired)
(require 'ag-hydra)
(require 'ag-which-key)
(require 'ag-ibuffer)

(require 'ag-diary)

(require 'ag-wgrep)
(require 'ag-mini-git)
(require 'ag-compile)

(require 'ag-lang-mode)

(require 'ag-hydra--main)
(def-hydras)

(require 'ag-global-keys)


;;;
(provide 'e-2025)

;;; EOF.
