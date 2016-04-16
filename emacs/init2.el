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
;; STOP: (global-auto-revert-mode t)
;;  -- Symbol's value as variable is void: \300



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
(when (and t window-system)
  (cond ((string-equal system-type "gnu/linux") 
         (progn
           (set-face-attribute 'default nil :font "Ubuntu Mono")
           ;; Inconsolata, EnvyCodeR, Consolas, Inconsolatazi4
           (let ((font-name "D2Coding"))
             ;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/
             (set-fontset-font "fontset-default" '(#x1100 . #xffdc) (cons font-name "unicode-bmp"))
             (set-fontset-font "fontset-default" '(#xe0bc . #xf66e) (cons font-name "unicode-bmp")))))
        ((string-equal system-type "darwin")
         (set-face-attribute 'default nil :family "Andale Mono" :height 135 :weight 'normal))
        ((string-equal system-type "windows-nt")
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))
;;; 한글 예시. Ll1| 0Oo@ [] {}








(require 'package)
(dolist (i '(("elpa" . "http://elpa.gnu.org/packages/")
             ("melpa" . "http://melpa.milkbox.net/packages/")
             ("marmalade" . "http://marmalade-repo.org/packages/")))
  (add-to-list 'package-archives i))
(package-initialize)



;; (when (and window-system
;;            (string-equal system-type "gnu/linux"))
;;   ;;(load-theme 'alect-light)
;;   ;;(load-theme 'solarized 1)
;;   ;;(load-theme 'leuven)
;;   )


(unless window-system
  (progn
    (require 'w3m-load nil t)
    (when (fboundp 'w3m-browse-url)
      (setq browse-url-browser-function #'w3m-browse-url))))





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









;;(add-to-list 'load-path (expand-file-name "~/local/slime-2.15/"))
;; (require 'slime-autoloads)
 
;; ;; Set your lisp system and, optionally, some contribs
;; ;; (setq inferior-lisp-program "/home/jhyun/local/sbcl-1.2.14-x86-64-linux/run-sbcl.sh")
;; ;; (setq inferior-lisp-program (expand-file-name "~/local/ccl/dx86cl64"))
;; ;; (setq inferior-lisp-program "/usr/bin/ecl")
;; ;; (setq inferior-lisp-program "/usr/bin/clisp")

;; (setq inferior-lisp-program (expand-file-name "~/local/sbcl/run-sbcl.sh"))

  


;; (setq slime-contribs '(slime-fancy))

;; (setq common-lisp-hyperspec-root (expand-file-name "~/local/HyperSpec/"))






;; (elpy-enable)
;; (if (string-equal system-type "darwin")
;;     (progn
;;       (setq elpy-rpc-python-command "/usr/local/bin/python3")
;;       (setq python-check-command "/usr/local/bin/flake8")
;;       (elpy-use-ipython "/usr/local/bin/ipython3"))
;;   (progn
;;     (elpy-use-ipython)))



(server-mode 1)



;; (setq twittering-icon-mode t)


;;; https://github.com/jwiegley/use-package
(add-to-list 'load-path (expand-file-name "~/.emacs.d/use-package"))
(load-library "use-package")

(use-package magit :ensure t)
(use-package markdown-mode :ensure t :pin melpa)
(use-package helm :ensure t :pin melpa)
(use-package unfill :ensure t :pin melpa)
(use-package centered-window-mode :ensure t :pin melpa)
(use-package projectile :pin melpa)
(use-package helm-projectile :ensure t :pin melpa)
(use-package helm-ag :ensure t :pin melpa)
(use-package ox-gfm :ensure t )


(eval-after-load "org"
  '(require 'ox-md nil t))



(use-package helm-projectile :ensure t :pin melpa)
(use-package helm-ag :ensure t :pin melpa)




(require 'helm-config)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)

;(centered-window-mode 1)



;;; helm-projectile.
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)


;;; for magit, ...
(setenv "EDITOR" "emacsclient")


(defun open-my-scratch-org-file ()
  (interactive)
  (find-file (expand-file-name "~/Dropbox/w/Scratch.txt")))





;; (setq load-path (cons "/usr/share/emacs/site-lisp/ess" load-path))
;; (require 'ess-site)



;;;EOF.
