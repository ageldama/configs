;;;; -*- mode: elisp; coding: utf-8; -*-

(setq inhibit-startup-screen t)

;;; load-path
(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))


;;; l10n, i18n...
;;(set-language-environment 'Korean)
;;(set-language-environment "UTF-8")
(setq default-input-method "korean-hangul")
;;(set-input-method "korean-hangul")
(prefer-coding-system 'utf-8-unix)
;;(utf-translate-cjk-load-tables)
;; (global-set-key [?\S- ] 'toggle-input-method)


;;; tabs & indents
(setq tab-width 4
  indent-tabs-mode nil)


;;; global-font-lock-mode
;;(global-font-lock-mode 1)


;;; ding-dang!
(setq visible-bell t)

;;; show column-no on modeline
(column-number-mode t)

;;; time/load
(display-time-mode -1)

;;; show matching parent?
(show-paren-mode t)


;;; visible mark region
(transient-mark-mode t)

;;; interactive-search
;(isearch-mode 1)

;;; interactive-completion
(icomplete-mode t)

;;; interactive-switch-buffer
(iswitchb-mode t)

;;; ido-mode
(require 'ido)
(ido-mode t)

;;; no backup files
(setq-default make-backup-files nil)
(setq-default version-control nil) ; backup uses version numbers?


;;; auto-revert
(global-auto-revert-mode t)


;;; 
(setq-default dired-dwim-target t)


;;; menu-bar -- turn-off when '-nw'
(if window-system
  (progn
    ;(tabbar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1))
  (progn
    (menu-bar-mode -1)))


;;; indents, spaces, tabs...
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;; fill, wrap, truncates
;;(setq-default fill-column 72)
(setq truncate-lines nil)
;(setq truncate-partial-width-windows nil)



;;; user?
(setq-default user-full-name "John, Jonghyouk Yun")
(setq-default user-mail-address "ageldama@gmail.com")


;;; grep-find, rgrep, find-grep-dired
;;(setq find-program "c:/cygwin/bin/find.exe")




;;; TODO: browse-url

;; cc-mode
(setq c-default-style "java")
(setq c-basic-offset 4)


;;; emacs-lisp-mode
;(setq lisp-indent-offset 2)


;;; org-mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)




;;; lusty-explorer
(when (require 'lusty-explorer nil 'noerror)
  ;; overrride the normal file-opening, buffer switching
  (global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
  (global-set-key (kbd "C-x b")   'lusty-buffer-explorer))


;;; for Netbooks
(display-time)
(display-battery-mode)



;;; gui-fonts
(when window-system
  (cond ((string-equal system-type "gnu/linux") 
         (set-face-attribute 'default nil :font "Inconsolata-11"))         
        ((string-equal system-type "windows-nt" system-type)
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))







(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)



(load-theme 'tango-dark)




;; setup load-path and autoloads
(add-to-list 'load-path "/home/jhyun/local/slime-2.9")
(require 'slime-autoloads)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/home/jhyun/local/sbcl-1.2.3-x86-64-linux/run-sbcl.sh")
;;(setq inferior-lisp-program "/home/jhyun/local/acl90express/alisp")
;;(setq inferior-lisp-program "/usr/bin/ecl")
;;(setq inferior-lisp-program "/usr/bin/clisp")
;;(setq inferior-lisp-program "/usr/bin/mkcl")
(setq slime-contribs '(slime-fancy))

(setq common-lisp-hyperspec-root "file:///home/jhyun/local/HyperSpec/")









;;;EOF
