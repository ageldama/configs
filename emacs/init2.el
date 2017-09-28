;; -*- mode: emacs-lisp; coding: utf-8; -*-

(setq inhibit-startup-screen t)

;;; l10n, i18n...
;;(set-language-environment 'Korean)
(setq default-input-method "korean-hangul")
(prefer-coding-system 'utf-8-unix)

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
      (menu-bar-mode +1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1))
  (progn
    (menu-bar-mode -1)))

;;; indents, spaces, tabs...
(setq-default indent-tabs-mode nil)
;;(setq-default tab-width 4)

;;; fill, wrap, truncates
(setq truncate-lines nil)

;;; user?
(setq-default user-full-name "Jong-Hyouk Yun")
(setq-default user-mail-address "ageldama@gmail.com")

;;; org-mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;;; gui-fonts
(when (and t window-system)
  (cond ((or (string-equal system-type "gnu/linux")
             (string-equal system-type "darwin"))
         (progn
           (set-face-attribute 'default nil
                               :font "Noto Sans Mono CJK KR"
                               ;; :font "SpoqaHanSans"
                               ;; :font "Inconsolata"
                               ;; :font "MMCedar"
                               ;; :font "Fantasque Sans Mono"
                               ;; :font "Hack"
                               ;; :font "Fira Code Light"                               
                               )
           ;; Inconsolata, EnvyCodeR, Consolas, Inconsolatazi4
           (let (
                 ;;(font-name "LexiSaebomR")
                 ;;(font-name "NanumBarunGothic")
                 ;;(font-name "Noto Sans Mono CJK KR")
                 ;;(font-name "JejuMyeongjo")
                 ;;(font-name "D2Coding")
                 ;;(font-name "나눔바른고딕")
                 (font-name "Noto Sans Mono CJK KR")
                 ;;(font-name "SpoqaHanSans")
                 ;;(font-name "아리따L")
                 )
             (set-fontset-font "fontset-default" '(#x1100 . #xffdc) (cons font-name "unicode-bmp"))
             (set-fontset-font "fontset-default" '(#xe0bc . #xf66e) (cons font-name "unicode-bmp")))))
        ((string-equal system-type "windows-nt")
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))

;;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/


;;; package.el
(require 'package)
(dolist (i '(("elpa" . "http://elpa.gnu.org/packages/")
             ("melpa" . "http://melpa.milkbox.net/packages/")
             ("marmalade" . "http://marmalade-repo.org/packages/")))
  (add-to-list 'package-archives i))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;;; macOS env-vars.
(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-initialize))


;;;
(use-package neotree :ensure t :pin melpa)

(use-package magit :ensure t)

(use-package markdown-mode :ensure t :pin melpa)

(use-package unfill :ensure t :pin melpa)

;;; helm, ag, projectile.
(use-package helm :ensure t :pin melpa
  :config (progn (require 'helm-config)
                 (helm-mode +1)
                 (setq helm-mode-fuzzy-match t                       
                       helm-recentf-fuzzy-match t
                       helm-buffers-fuzzy-matching t
                       helm-recentf-fuzzy-match t
                       helm-buffers-fuzzy-matching t
                       helm-locate-fuzzy-match t
                       helm-M-x-fuzzy-match t
                       helm-semantic-fuzzy-match t
                       helm-imenu-fuzzy-match t
                       helm-apropos-fuzzy-match t
                       helm-lisp-completion-at-point t)
                 (global-set-key (kbd "M-x") 'helm-M-x)
                 (global-set-key (kbd "C-x C-f") 'helm-find-files)
                 (global-set-key (kbd "C-x b") 'helm-mini)))

(use-package helm-ag :ensure t :pin melpa)

(use-package projectile :pin melpa
  :config (projectile-global-mode))

(use-package helm-projectile :ensure t :pin melpa
  :config (progn (setq projectile-completion-system 'helm)
                 (helm-projectile-on)))

;;; flycheck.
(use-package flycheck :ensure t :pin melpa
  :config (global-flycheck-mode +1))

;;; company.
(use-package company :ensure t :pin melpa
  :config (progn (require 'company)
                 (global-set-key (kbd "C-c TAB") 'company-complete)                 
                 (add-hook 'after-init-hook 'global-company-mode)
                 ;; NOT-SURE: (setq company-backends (delete 'company-semantic company-backends))
                 ))

;;; powerline.
(when nil
  (use-package powerline :ensure t :pin melpa)
  (use-package airline-themes :ensure t :pin melpa))

;;; colortheme.
(when window-system
  (use-package leuven-theme :ensure t :pin melpa
    :config (load-theme #'leuven t)))

;;; windmove
(when (package-installed-p 'windmove)
  (global-set-key (kbd "C-c <left>")  'windmove-left)
  (global-set-key (kbd "C-c <right>") 'windmove-right)
  (global-set-key (kbd "C-c <up>")    'windmove-up)
  (global-set-key (kbd "C-c <down>")  'windmove-down))

;;; rainbow-delimiters
(use-package rainbow-delimiters  :ensure t :pin melpa
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;;; which-key
(use-package which-key
	:ensure t 
	:config
	(which-key-mode))

;;; evil!
(use-package evil :ensure t :pin melpa
  :config
  (progn (global-linum-mode -1)
         (evil-mode -1)
         (global-set-key (kbd "C-<f12>") 'evil-local-mode)
         (add-to-list 'evil-emacs-state-modes 'neotree-mode)))

(use-package evil-vimish-fold :ensure t :pin melpa
  :config (evil-vimish-fold-mode 1))

;;; darkroom
(use-package writeroom-mode :ensure t :pin melpa)


;;; elpy, jedi.
(when t
  (use-package elpy :ensure t :pin melpa)  
  (use-package jedi :ensure t :pin melpa)
  (use-package pylint :ensure t :pin melpa)
  ;;
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (elpy-enable)
  (add-hook 'python-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil)
              (setq tab-width 4)
              (setq python-indent 4)))
  (require 'ob-python))


;;; diary, org.
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

(defun open-my-scratch-org-file ()
  (interactive)
  (find-file (expand-file-name "~/Dropbox/w/Scratch.txt")))






;;;EOF.
