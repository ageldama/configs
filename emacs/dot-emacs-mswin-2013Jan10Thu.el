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
(isearch-mode 1)

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

;;; fill
;;(setq-default fill-column 72)


;;; user?
(setq-default user-full-name "Jonghyouk Yun")
(setq-default user-mail-address "ageldama@gmail.com")


;;; grep-find, rgrep, find-grep-dired
;;(setq find-program "c:/cygwin/bin/find.exe")


;;; color-theme
(require 'color-theme nil t)

(when (fboundp 'color-theme-initialize)
  (progn
    (color-theme-initialize)
    (setq color-theme-is-global t)
    (color-theme-calm-forest)
  ))


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
(let ((font-name "바탕체"))
  (when window-system
    (set-fontset-font "fontset-default" '(#x1100 . #xffdc)  (cons font-name "unicode-bmp"))
    (set-fontset-font "fontset-default" '(#xe0bc . #xf66e)  (cons font-name "unicode-bmp"))))




;;;
;;(load-file "~/local/slime-sbcl.el")


;;;
;;(setq-default haskell-doc-mode t)


;;; scala-mode
;; (add-to-list 'load-path "c:/dev/scala-mode")
;; (require 'scala-mode-auto)
;; (add-to-list 'load-path "c:/dev/ensime/elisp/")
;; (require 'ensime)
;; (add-hook 'scala-mode-hook 'ensime-scala-mode-hook) 


;;; themes
(defconst +themes-dir+ "c:/dev/emacs-themes/")
(add-to-list 'load-path +themes-dir+)
(add-to-list 'custom-theme-load-path +themes-dir+)
(load-theme 'zenburn t)
;(load-theme 'solarized-dark t)


;;; my-humble-word
(defun my-humble-word ()
  (interactive)
  (progn
    (setq-local fill-forward-paragraph-function (lambda (x) 0))
    (toggle-truncate-lines 0)))

;;; clojure
(add-to-list 'load-path "c:/dev/clojure-mode")
(require 'clojure-mode)

(add-to-list 'load-path "c:/dev/nrepl.el")
(require 'nrepl)

;;; EOF

