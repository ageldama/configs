;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; setup self

(require 'f)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (f-dirname load-file-name))

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (f-join %myself-dir rel-path) load-path
              :test #'equal))

(%add-load-path-under-myself "elisp")

;;; commons

(require 'ag-el)
(require 'ag-emacs-sensible)
(require 'ag-hippie-expand)
(require 'ag-font)
(require 'ag-package)
;; (require 'ag-fundamental-mode)
(require 'ag-gc)
(require 'ag-battery-saving-mode)

(require 'ag-org)
(require 'ag-plantuml)
(require 'ag-ditaa)

(require 'ag-writeroom-mode)

(require 'ag-modus-themes)
;; (require 'ag-smart-mode-line)

(require 'ag-dired)
(require 'ag-avy)
(require 'ag-hydra)
(require 'ag-which-key)
(require 'ag-ace-window)
(require 'ag-ibuffer)

(require 'ag-expand-region)
(require 'ag-hydra--expand-region)

(require 'ag-diary)

(require 'ag-wgrep)
(require 'ag-mini-git)
(require 'ag-compile)
(require 'ag-undo-tree)
(require 'ag-diminish)
(require 'ag-evil)

(require 'ag-lang-mode)

(require 'ag-hydra--main)
(require 'ag-hydra--tab)

(def-hydras)

(require 'ag-global-keys)


;;;
(provide 'e-2025)

;;; EOF.
