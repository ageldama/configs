;;;; -*- mode: emacs-lisp; coding: utf-8; -*-

(setq inhibit-startup-screen t)

;;; load-path
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))


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
;(iswitchb-mode t)

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
(unless (string-equal system-type "darwin")
  (display-battery-mode))




;;; gui-fonts
(when window-system
  (cond ((string-equal system-type "gnu/linux") 
         (progn
           (set-face-attribute 'default nil :font "EnvyCodeR-13")
           ;; Inconsolata, EnvyCodeR, Consolas, Inconsolatazi4
           (let ((font-name "나눔고딕코딩"))
             (set-fontset-font "fontset-default" '(#x1100 . #xffdc) (cons font-name "unicode-bmp"))
             (set-fontset-font "fontset-default" '(#xe0bc . #xf66e) (cons font-name "unicode-bmp")))))
        ((string-equal system-type "darwin")
         (set-face-attribute 'default nil :family "Andale Mono" :height 135 :weight 'normal))
        ((string-equal system-type "windows-nt" system-type)
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))







(require 'package)
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("elpy" . "https://jorgenschaefer.github.io/packages/"))
(package-initialize)



(when (and window-system
           (string-equal system-type "gnu/linux"))
  ;;(load-theme 'alect-light)
  (load-theme 'solarized 1)
  ;;(load-theme 'leuven)
  )


(unless window-system
  (progn
    (require 'w3m-load nil t)
    (when (fboundp 'w3m-browse-url)
      (setq browse-url-browser-function #'w3m-browse-url))))













;;;EOF
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "869b11b64da20b6b04e9b18721e03a58e5d9f0ee3a7a91bfe7cdc2b24a828109" "e890fd7b5137356ef5b88be1350acf94af90d9d6dd5c234978cd59a6b873ea94" default)))
 '(line-number-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "white")))))

;(load-theme 'deeper-blue)

;(load "~/local/io-mode/io-mode.el")



(require 'cl)

(defun en-date-time ()
  (cl-flet ((en-week-day-name (n)
                              (let* ((a '((0 . "Sun") (1 . "Mon") 
                                          (2 . "Tue") (3 . "Wed")
                                          (4 . "Thu") (5 . "Fri") 
                                          (6 . "Sat")))
                                     (i (assoc n a)))
                                (cdr i)))
            (en-month-name (n)
                           (let* ((a '((1 . "Jan") (2 . "Feb") 
                                       (3 . "Mar") (4 . "Apr")
                                       (5 . "May") (6 . "Jun") 
                                       (7 . "Jul") (8 . "Aug")
                                       (9 . "Sep") (10 . "Oct") 
                                       (11 . "Nov") (12 . "Dec")))
                                  (i (assoc n a)))
                             (cdr i))))
    (let* ((year (format-time-string "%Y"))
           (month-num (string-to-number (format-time-string "%m")))
           (month-name (en-month-name month-num))
           (day (format-time-string "%d"))
           (day-of-week-num (string-to-number (format-time-string "%w")))
           (day-of-week-name (en-week-day-name day-of-week-num))
           (date-str (format "%s/%s/%s/%s" year month-name day day-of-week-name)))
      date-str)))


(defun insert-markdown-journal-header ()
  (interactive)
  (progn
    (markdown-mode)
    (insert (format "-*- mode: markdown; coding: utf-8; -*-\n\n# %s" (en-date-time)))))

(defun insert-org-journal-header ()
  (interactive)
  (progn
    (org-mode)
    (insert (format "# -*- mode: org; coding: utf-8; -*-\n\n#+TITLE: %s" (en-date-time)))))



(require 'ob-emacs-lisp)




(add-to-list 'load-path (expand-file-name "~/local/slime-2.15/"))
(require 'slime-autoloads)

;; ;(add-to-list 'load-path "/home/jhyun/local/slime-company/")

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/home/jhyun/local/sbcl-1.2.16-x86-64-linux/run-sbcl.sh")
;; (setq inferior-lisp-program (expand-file-name "~/local/ccl/dx86cl64"))
;; (setq inferior-lisp-program "/usr/bin/ecl")
;; (setq inferior-lisp-program "/usr/bin/clisp")
(setq slime-contribs '(slime-fancy ))

(setq common-lisp-hyperspec-root (expand-file-name "~/local/HyperSpec/"))

(require 'ob-lisp) ;; org-babel lisp support.




(elpy-enable)
(if (string-equal system-type "darwin")
    (progn
      (setq elpy-rpc-python-command "/usr/local/bin/python3")
      (setq python-check-command "/usr/local/bin/flake8")
      (elpy-use-ipython "/usr/local/bin/ipython3"))
  (progn
    (elpy-use-ipython)))

(require 'ob-python)


(server-mode 1)



;; (setq twittering-icon-mode t)


;; (package-install 'ag)
;; (package-install 'magit)
;; (package-install 'markdown-mode)
;; (package-install 'elpy)
;; (package-install 'helm)
;; (package-install 'unfill)
;; (package-install 'centered-window-mode)
;; (package-install 'color-theme-solarized)

(require 'helm-config)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)

(centered-window-mode 1)


;;; for magit, ...
(setenv "EDITOR" "emacsclient")



(find-file (expand-file-name "~/Dropbox/w/Scratch.txt"))

;;;EOF.

