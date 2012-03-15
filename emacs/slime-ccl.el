;;;; -*- mode: emacs-lisp; coding: utf-8; -*-

(add-to-list 'load-path "c:/local/slime-2012-03-07")
;(setq inferior-lisp-program "C:/local/ccl-1.7-windowsx86/ccl-1.7/wx86cl64.exe")
(setq inferior-lisp-program "C:/local/ccl-1.7/wx86cl.exe")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)

;;; NOTE: path-must-trailling-'/'!!!
;;; NOTE: specify-dir that 'hyperspec/'... -> Body/, ...
(setq common-lisp-hyperspec-root "c:/local/hyperspec-7-0/hyperspec/")

(slime-setup '(slime-fancy))
;(slime-setup)
;(slime)
