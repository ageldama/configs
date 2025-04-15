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

(defun ag-requires (&rest require-syms)
  (interactive)
  (cl-loop for require-sym in require-syms
           do (require require-sym)))

(ag-requires 'ag-package
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
