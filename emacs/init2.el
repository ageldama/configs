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
;;(setq tab-width 4 indent-tabs-mode nil)


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
;;(setq-default tab-width 4)

;;; fill, wrap, truncates
;;(setq-default fill-column 72)
(setq truncate-lines nil)
;(setq truncate-partial-width-windows nil)



;;; user?
(setq-default user-full-name "Jong-Hyouk Yun")
(setq-default user-mail-address "jong-hyouk.yun@zalando.de")


;;; grep-find, rgrep, find-grep-dired
;;(setq find-program "c:/cygwin/bin/find.exe")






;; cc-mode
;; (setq c-default-style "java")
;; (setq c-basic-offset 4)


;;; emacs-lisp-mode
;(setq lisp-indent-offset 2)


;;; org-mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)

(add-hook 'org-mode-hook (lambda ()
                           (set-face-attribute 'italic nil
                                               :inherit 'underline)))





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
           (let (
                 ;;(font-name "LexiSaebomR")
                 ;; (font-name "NanumBarunGothic")
                 ;;(font-name "Noto Sans Mono CJK KR")
                 ;;(font-name "JejuMyeongjo")
                 ;;(font-name "D2Coding")
                 ;;(font-name "나눔명조")
                 ;;(font-name "Noto Sans Mono CJK KR")
                 (font-name "본고딕 Normal")
                 )
             (set-fontset-font "fontset-default" '(#x1100 . #xffdc) (cons font-name "unicode-bmp"))
             (set-fontset-font "fontset-default" '(#xe0bc . #xf66e) (cons font-name "unicode-bmp")))))
        ((string-equal system-type "darwin")
         (set-face-attribute 'default nil :family "Andale Mono" :height 135 :weight 'normal))
        ((string-equal system-type "windows-nt")
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))

;;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/







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



;; (server-mode 1)



;; (setq twittering-icon-mode t)


;;; https://github.com/jwiegley/use-package
(add-to-list 'load-path (expand-file-name "~/.emacs.d/use-package"))
(load-library "use-package")

(use-package magit :ensure t)
(use-package markdown-mode :ensure t :pin melpa)
(use-package helm :ensure t :pin melpa)
(use-package unfill :ensure t :pin melpa)
;; (use-package centered-window-mode :ensure t :pin melpa)
(use-package projectile :pin melpa)
(use-package helm-projectile :ensure t :pin melpa)
(use-package helm-ag :ensure t :pin melpa)

;;(use-package jedi :ensure t :pin melpa)
;;(add-hook 'python-mode-hook 'jedi:setup)

(use-package elpy :ensure t :pin melpa)
(elpy-enable)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent 4)))

(require 'ob-python)




(when nil
  (use-package cmake-mode :ensure t :pin melpa)
  
  (use-package rtags :ensure t :pin melpa)
  (use-package cmake-ide :ensure t :pin melpa)

  (when (string-equal system-type "darwin")
    (setq rtags-path "/usr/local/bin/"))

  (require 'rtags) ;; optional, must have rtags installed

  ;;(add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
  ;;(add-hook 'c++-mode-common-hook 'rtags-start-process-unless-running)

  (when (string-equal system-type "darwin")
    (progn
      (setq cmake-ide-rdm-executable "/usr/local/bin/rdm")
      (setq cmake-ide-rc-executable "/usr/local/bin/rc")
      (setq cmake-ide-cmake-command "/usr/local/bin/cmake")))

  (cmake-ide-setup)
)

(use-package flycheck :ensure t :pin melpa)
(global-flycheck-mode)

(use-package company :ensure t :pin melpa)
(when (string-equal system-type "darwin")
  (setq company-clang-executable "/usr/bin/clang"))
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(setq company-backends (delete 'company-semantic company-backends))

(when (boundp 'c-mode-map)
  (define-key c-mode-map  [(tab)] 'company-complete)
  (define-key c++-mode-map  [(tab)] 'company-complete))



;; (use-package ac-clang :ensure t :pin melpa)
;; (require 'ac-clang)
;; (setq ac-clang--server-executable "/Users/jhyun/local/bin/clang-server")
;; (ac-clang-initialize)

;; (require 'auto-complete-config)
;; ;; (require 'auto-complete-clang)
;; (setq ac-auto-start t)
;; (setq ac-quick-help-delay 0.5)
;; ;; (ac-set-trigger-key "TAB")
;; ;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)



(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-initialize))



;; (use-package ox-gfm :ensure t )
;; (eval-after-load "org"
;;  '(require 'ox-md nil t))


;; (use-package adoc-mode :ensure t :pin melpa)
;; (use-package ox-asciidoc :ensure t :pin melpa)
;; (eval-after-load "org"
;;  '(require 'ox-asciidoc nil t))
;; (add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))




(require 'helm-config)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)

;;(centered-window-mode 1)



;;; helm-projectile.
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)



;;; powerline.
(use-package powerline :ensure t :pin melpa)
(use-package airline-themes :ensure t :pin melpa)
(require 'powerline)
(require 'airline-themes)
;;(airline-themes-solarized-gui)
(load-theme 'airline-light)



;;; go-lang.
(use-package go-mode :ensure t :pin melpa)

(when (and (fboundp 'go-mode) (memq window-system '(mac ns)))
  (use-package exec-path-from-shell :ensure t :pin melpa)
  (exec-path-from-shell-copy-env "GOROOT")
  (exec-path-from-shell-copy-env "GOPATH"))

(use-package go-eldoc :ensure t :pin melpa)
(add-hook 'go-mode-hook 'go-eldoc-setup)

(use-package go-autocomplete :ensure t :pin melpa)
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)



;;; for magit, ...
(setenv "EDITOR" "emacsclient")



(defun open-my-scratch-org-file ()
  (interactive)
  (find-file (expand-file-name "~/Dropbox/w/Scratch.txt")))





;; (setq load-path (cons "/usr/share/emacs/site-lisp/ess" load-path))
;; (require 'ess-site)



;;;EOF.
