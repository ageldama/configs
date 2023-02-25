;;; -*- mode: emacs-lisp; coding: utf-8; -*-
(setq user-full-name    "Jong-Hyouk Yun")
(setq user-mail-address "ageldama@gmail.com")

(setq inhibit-startup-screen  t
      vc-follow-symlinks      t
      )


;; Don't forget `M-x esup', profile your `.emacs'.
(setq gc-cons-threshold
      (if (< (or (car (memory-info)) 9999999999999999)
             (* 1024 1024 8))
          (* 1024 1024 500) ; 500 MiB
        ;; or, 100 MiB
        (* 1024 1024)))

(defvar *my-gc-timer* nil)

(defun my-gc-start-timer ()
  (interactive)
  (when (null *my-gc-timer*)
    (setq *my-gc-timer*
          (run-with-idle-timer 60 t
                               (lambda ()
                                 (garbage-collect))))))

(defun my-gc-cancel-timer ()
  (interactive)
  (when *my-gc-timer*
    (cancel-timer *my-gc-timer*)
    (setq *my-gc-timer* nil)))

(defun my-gc-toggle-timer ()
  (interactive)
  (if *my-gc-timer*
      (progn (my-gc-cancel-timer)
             (message "GC timer: cancelled"))
    (progn (my-gc-start-timer)
           (message "GC timer: started -- %s" *my-gc-timer*))))

(my-gc-start-timer)


(defun toggle-battery-saving-mode ()
  (interactive)
  (call-interactively #'global-flycheck-mode -1)
  (call-interactively #'global-eldoc-mode    -1)
  (call-interactively #'global-company-mode  -1)
  ;;(global-hl-todo-mode)
  )


;; (setq battery-mode-line-format "[%b%p%%, %m-mins.]")



;;; tags
(defun tags/refresh ()
  "Read TAGS of current buffer. (buffer locally)"
  (interactive)
  (let ((tags-revert-without-query t))  ; don't query, revert silently
    (visit-tags-table tags-file-name t)))



;;;
(require 'cl-lib)


(defconst +sys/gui?+
  (display-graphic-p)
  "Are we running on a GUI Emacs?")

(defconst +sys/winnt?+
  (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(defconst +sys/linux?+
  (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux system?")

(defconst +sys/bsd?+
  (eq system-type 'berkeley-unix)
  "BSD?")

(defconst +sys/unix-like?+
  (or +sys/linux?+ +sys/bsd?+))

(defconst +sys/mac?+
  (eq system-type 'darwin)
  "Are we running on a Mac system?")



(set-language-environment     "UTF-8")
(prefer-coding-system         'utf-8)
(set-selection-coding-system  'utf-8)
(set-default-coding-systems   'utf-8)
(set-terminal-coding-system   'utf-8)
(set-keyboard-coding-system   'utf-8)
(setq                         locale-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
;; NOTE: the default is just fine.
;; (when +sys/gui?+
;;   (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))


(setq default-input-method   "korean-hangul") ; 인코딩, 언어환경 설정 이후에 적용해야함.




;; Display column numbers in modeline
(column-number-mode  t)

(global-hl-line-mode -1) ; no thx


(show-paren-mode     t) ; show matching paren
(transient-mark-mode t) ; make transient block visible




;; (setq browse-url-browser-function
;;       'browse-url-firefox)

(global-auto-revert-mode t)


;; cuz annoying
(global-whitespace-mode -1)
(setq-default show-trailing-whitespace t)


;;
(setq-default indent-tabs-mode nil) ; suppress using TAB chars for indentation.

(setq tab-width nil) ;; ONLY affects to REAL <TAB>-chars to display.

(setq c-basic-offset 2)

;;(global-set-key "\t" (lambda () (interactive) (insert-char 32 2))) ;; [tab] inserts two spaces

(electric-indent-mode +1)


;;; hippie-expand
(defadvice hippie-expand (around hippie-expand-case-fold)
  "Try to do case-sensitive matching (not effective with all functions)."
  (let ((case-fold-search nil))
    ad-do-it))
(ad-activate 'hippie-expand)



(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Bye??? "))
          'append)


;;; no backup files
(setq make-backup-files nil)
(setq version-control   nil)   ; backup uses version numbers?

;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))

;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))

;; (setq auto-save-file-name-transforms
;;   `((".*" "~/.emacs-saves/" t)))

;; (setq create-lockfiles nil)



;;; similar buffer names
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;;; never truncate-lines
(set-default 'truncate-lines nil)

;;;
(if +sys/gui?+
    (progn
      (menu-bar-mode   -1)
      (tool-bar-mode   -1)
      (scroll-bar-mode -1))
  (progn
    (menu-bar-mode   -1)))


(display-time-mode   -1)
(display-battery-mode -1)






(global-set-key (kbd "C-x C-b") #'ibuffer)

(global-set-key (kbd "S-<left>") #'tab-previous)
(global-set-key (kbd "S-<right>") #'tab-next)
(global-set-key (kbd "S-<down>") #'tab-new)


;;; package.el
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if nil "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; (add-to-list 'package-archives (cons "marmalade" (concat proto "://marmalade-repo.org/packages/")) t)
  (add-to-list 'package-archives (cons "org" (concat proto "://orgmode.org/elpa/")) t)
  ;; (when (< emacs-major-version 24)
  ;;   (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/"))))
  )
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(use-package quelpa :ensure t :pin melpa
  ;; big startup/init speed boosts:
  :config (setq quelpa-checkout-melpa-p  nil ; don't use it
                quelpa-update-melpa-p    nil ; and don't even update it
                ))

;;; NOTE do this manually:
;; (quelpa-checkout-melpa)

(use-package f :ensure t)
(use-package s :ensure t)



;;; GUI fonts
;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/

(defcustom *ageldama/set-font-fixed?* t "...")
(defcustom *ageldama/font-fixed-en* "DejaVu Sans Mono" "eng")
(defcustom *ageldama/font-fixed-ko* "KoPub바탕체" "kor")

(defun my-set-fixed-fonts ()
  (interactive)
  (when *ageldama/set-font-fixed?*
    (let ((en-fn
           *ageldama/font-fixed-en*
           )
          (ko-fn
           *ageldama/font-fixed-ko*
           ))
      ;; default Latin font (e.g. Consolas)
      (set-frame-font en-fn t)
      (set-face-attribute 'default nil :family en-fn)
      ;; default font size (point * 10)
      ;; NOTE depending on the default font,
      ;; if the size is not supported very well, the frame will be clipped
      ;; thus the beginning of the buffer may not be visible correctly.
      (set-face-attribute 'default nil :height 110)
      ;; use specific font for Korean charset.
      ;; if you want to use different font size for specific charset,
      ;; add :size `POINT-SIZE' in the font-spec.
      (set-fontset-font t 'hangul (font-spec :name ko-fn)))))

(defun my-set-variable-fonts ()
  (interactive)
  (set-frame-font "Noto Serif CJK KR" t)
  (set-fontset-font t 'hangul (font-spec :name "Noto Serif CJK KR")))

(defun which-active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc (lambda (mode) (condition-case nil
                             (if (and (symbolp mode) (symbol-value mode))
                                 (add-to-list 'active-modes mode))
                           (error nil) ))
          minor-mode-list)
    (message "Active modes are %s" active-modes)
    active-modes))

(defun my-auto-set-font-fixed-or-variable (&rest arguments)
  (if (memq 'buffer-face-mode (which-active-modes))
      (my-set-variable-fonts)
    (my-set-fixed-fonts)))

(advice-add #'variable-pitch-mode
            :after #'my-auto-set-font-fixed-or-variable)


(when +sys/gui?+
  (cond ((or +sys/unix-like?+ ;;+sys/mac?+
             )
         (my-set-fixed-fonts))
  	;; Windows
        (+sys/winnt?+
         (set-face-attribute 'default nil :font "Consolas-11"))
        (t :unknown)))



;;; cleaner modeline.
(use-package diminish :ensure t :pin melpa
  :config
  (progn
    (add-hook 'auto-revert-mode-hook
              (lambda () (diminish 'auto-revert-mode)))
    (add-hook 'ivy-mode-hook (lambda ()
                               (diminish 'ivy-mode)))
    (diminish 'hs-minor-mode)
    (diminish 'counsel-mode)
    (diminish 'ivy-mode)
    (diminish 'undo-tree-mode)))

;;; Hydra
(use-package hydra :ensure t :pin melpa)

;;; which-key
(use-package which-key :ensure t
  :diminish which-key-mode
  :config (progn (which-key-mode)
                 (which-key-setup-side-window-bottom)
                 (setq which-key-max-description-length 200)))


;;; vimish-fold
(when t
  (use-package vimish-fold :ensure t :pin melpa
    :after evil
    :config (progn (vimish-fold-global-mode +1)
                   (global-set-key (kbd "C-c @ t") 'vimish-fold-toggle)
                   (global-set-key (kbd "C-c @ f") 'vimish-fold)
                   (global-set-key (kbd "C-c @ d") 'vimish-fold-delete)))

  (use-package evil-vimish-fold
    :ensure t :pin melpa
    :after vimish-fold
    :hook ((prog-mode conf-mode text-mode) . evil-vimish-fold-mode))
  )


;;; matchit
(use-package evil-matchit :ensure t :pin melpa :after evil
  :config (global-evil-matchit-mode +1))


;;; trees, files, and directories!
(use-package treemacs :ensure t :pin melpa)

(use-package neotree :ensure t :pin melpa)


;;; helpful, discover-my-major
(use-package helpful :pin melpa :ensure t
  :config (progn
            (setq counsel-describe-function-function #'helpful-callable)
            (setq counsel-describe-variable-function #'helpful-variable)
            (global-set-key (kbd "C-h f") #'helpful-callable)
            (global-set-key (kbd "C-h v") #'helpful-variable)
            (global-set-key (kbd "C-h k") #'helpful-key)
            (global-set-key (kbd "C-h C-.") #'helpful-at-point)))



;;; markdown syntax highlighting and exporting
(use-package markdown-mode :ensure t :pin melpa
  :config (progn (setq markdown-command "pandoc")
                 (add-hook 'markdown-mode-hook
                           'turn-on-auto-fill)))



;;; inverse of `fill-text'
(use-package unfill :ensure t :pin melpa)


;;; highlights TODO, FIXME, DONT, FAIL, NOTE, TEMP, HACK, etc.
(use-package hl-todo :ensure t :pin melpa
  :config (global-hl-todo-mode +1))



;;; menu-ber.
(global-set-key (kbd "M-`")       'menu-bar-open)
(global-set-key (kbd "<f10>")       'menu-bar-open)


;;;
(use-package prescient :ensure t :pin melpa)
;; (use-package company-prescient :ensure t :pin melpa)


;;; Counsel, Ivy, Swiper.
(when t
  (use-package ivy-prescient :ensure t :pin melpa
    :after counsel
    :config (ivy-prescient-mode))

  (use-package counsel :ensure t :pin melpa
    :diminish
    :config (progn
              ;;
              (ivy-mode 1)
              (setq ivy-use-selectable-prompt     t  ;; <C-p>.
                    ivy-use-virtual-buffers       t
                    enable-recursive-minibuffers  t
                    ivy-re-builders-alist         '((swiper      . ivy--regex-plus)
                                                    (counsel-M-x . ivy--regex-fuzzy)
                                                    (t           . ivy--regex-plus)))
              (global-set-key "\C-s" 'swiper)
              (global-set-key (kbd "M-s s") 'swiper-thing-at-point)
              (global-set-key (kbd "C-c C-r") 'ivy-resume)
              (global-set-key (kbd "<f6>") 'ivy-resume)
              (global-set-key (kbd "M-x") 'counsel-M-x)
              (global-set-key (kbd "C-x C-f") 'counsel-find-file)
              (global-set-key (kbd "C-h a") 'counsel-apropos)
              ;; USE `helpful' INSTEAD:
              ;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
              ;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
              (global-set-key (kbd "<f1> l") 'counsel-find-library)
              (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
              (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
              (global-set-key (kbd "C-c g") 'counsel-git)
              (global-set-key (kbd "C-c j") 'counsel-git-grep)
              ;; (global-set-key (kbd "C-c k") 'counsel-rg)
              ;; (global-set-key (kbd "C-x l") 'counsel-locate)
              ;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
              (global-set-key (kbd "M-y") 'counsel-yank-pop)
              (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

  ;; `C-o` in Ivy minibuf.
  (use-package ivy-hydra :ensure t :pin melpa)

  (use-package ivy-rich :ensure t :pin melpa
    :config (ivy-rich-mode +1))
  )



;;; wgrep: writable grep
(use-package wgrep :ensure t :pin melpa)

;;; projectile
(use-package projectile :pin melpa
  :config
  (progn (projectile-global-mode)
         ;;(diminish 'projectile-mode)
         (setq projectile-mode-line-prefix " Prj")
         (define-key projectile-mode-map (kbd "C-c p")
           'projectile-command-map)

         ;; for xref :
         (cl-defmethod project-roots ((project (head projectile)))
           (list (cdr project)))
         ))

(use-package counsel-projectile :ensure t :pin melpa
  :config
  (setq counsel-projectile-rg-initial-input  '(projectile-symbol-or-selection-at-point)))

(defun counsel-rg-maybe-projectile ()
  (interactive)
  (cl-flet ((counsel-rg-thing-at-point ()
                                       (interactive)
                                       (let  ((tap (thing-at-point 'symbol)))
                                         (if (null tap)
                                             (counsel-rg)
                                           (counsel-rg tap)))))
    (let ((tap (thing-at-point 'symbol)))
      (if (projectile-project-p)
          (counsel-projectile-rg)
        (counsel-rg-thing-at-point)))))


;;; deadgrep
(use-package deadgrep :ensure t :pin melpa
  :config (global-set-key (kbd "C-c k") 'deadgrep))



;;; undo-tree
(use-package undo-tree
  :diminish 
  :ensure t
  :init (global-undo-tree-mode)
  :config (setq undo-tree-auto-save-history nil))



;;; Git
(use-package magit :ensure t :pin melpa)


(defun omz-ish/gwip ()
  (interactive)
  (magit-with-toplevel
    (message "git-wip-commit: %s"
             (shell-command-to-string
              "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]'"))))




;;; hippie-expand, zap-up-to-char

(global-set-key "\M-z" 'zap-up-to-char)

(global-set-key "\M-/" 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill
        try-complete-file-name-partially try-complete-file-name
        try-expand-all-abbrevs try-expand-list try-expand-line
        try-complete-lisp-symbol-partially try-complete-lisp-symbol))




;;; flycheck.
(use-package flycheck :ensure t :pin melpa
  :config (global-flycheck-mode +1))

;;(use-package flycheck-pos-tip :ensure t :pin melpa
;;  :config (with-eval-after-load 'flycheck
;;            (flycheck-pos-tip-mode)))


;;; company.
(use-package company :ensure t :pin melpa
  :diminish company-mode
  :config (progn (require 'company)
                 (setq company-idle-delay 0.2)
		 (global-company-mode +1)
                 ;; (global-set-key (kbd "C-TAB") 'company-complete)
		 ;; (global-set-key (kbd "C-c \\") 'company-complete)
                 ;; (global-set-key (kbd "C-c \\") 'counsel-company)
		 (define-key company-active-map (kbd "RET") 'company-complete-selection)
		 (define-key company-active-map (kbd "<prior>") 'company-previous-page)
		 (define-key company-active-map (kbd "<next>") 'company-next-page)

                 (let ((map company-active-map))
                   (define-key map (kbd "<tab>") 'company-complete-common-or-cycle))
                 (let ((map company-active-map))
                   (define-key map (kbd "<backtab>") 'company-select-previous))

                 (with-eval-after-load 'company
                   (define-key company-active-map (kbd "C-M-i") #'company-complete)
                   (define-key company-active-map (kbd "C-SPC") #'company-complete-selection)
                   (define-key company-active-map (kbd "<C-return>") #'company-complete-selection))

                 ;;
		 (setq company-tooltip-align-annotations t)
		 (add-hook 'after-init-hook 'global-company-mode)))

(defmacro bind-company-local-key (hook key)
  `(add-hook ,hook
             (lambda () (local-set-key ,key 'company-capf))))

(bind-company-local-key 'prog-mode-hook (kbd "C-c TAB"))
(bind-company-local-key 'text-mode-hook (kbd "C-c TAB"))

;;; eldoc
(use-package eldoc :ensure t :pin melpa :diminish eldoc-mode)

;;; Org
(add-hook 'org-mode-hook
          (lambda ()
            (turn-on-auto-fill)
            (flycheck-mode -1)
            ;; (setq truncate-lines nil)
            ;; (setq fill-column most-positive-fixnum)
            ;; (turn-off-auto-fill)
            (local-set-key (kbd "C-c l") 'org-store-link)
            ;; NOTE: conflicts = <tab>
            ;; (when (fboundp 'yas-minor-mode)
            ;;   (yas-minor-mode -1))
            (setq org-adapt-indentation t)
            ))

(setq org-log-done 'time)
(setq org-startup-with-inline-images t)

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance '("crypt"))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)


;; https://emacs.stackexchange.com/a/45623/20004
(require 'org-attach)
(setq org-link-abbrev-alist '(("org-attach" . org-attach-expand-link)))


;;; org-capture
(setq org-default-notes-file "~/P/v3/CAPTURE.org")

(defun org-capture-open ()
  (interactive)
  (find-file org-default-notes-file))


;;;
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-agenda-files '("~/P/v3/PLAN.org" "~/P/v3/CAPTURE.org"))


;;; PlantUML
(use-package plantuml-mode :ensure t :pin melpa
  :config
  (setq plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")
  (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")

  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages '((plantuml . t))))

  (setq org-confirm-babel-evaluate nil)

  (add-hook 'org-babel-after-execute-hook
            (lambda ()
              (when org-inline-image-overlays
                (org-redisplay-inline-images))))

  ;; TODO C-c C-,
  ;; <u"<TAB>"
  ;; (add-to-list 'org-structure-template-alist
  ;;              '("u" "#+BEGIN_SRC plantuml :file ?.png
  ;;                   \nskinparam monochrome true
  ;;                   \n#+END_SRC"))
  )


;;; writeroom?
(use-package writeroom-mode :ensure t :pin melpa)




;;; Window move.
(use-package ace-window :ensure t :pin melpa
  :config (global-set-key (kbd "C-x o") 'ace-window))

(defun ace-swap-window-last ()
  (interactive)
  (aw-swap-window (previous-window)))

;;; buf-move-*
(use-package buffer-move :ensure t :pin melpa)

;;;
(defun window-toggle-split-direction ()
  "Switch window split from horizontally to vertically, or vice versa.
i.e. change right window to bottom, or change bottom window to right."
  (interactive)
  (require 'windmove)
  (let ((done))
    (dolist (dirs '((right . down) (down . right)))
      (unless done
        (let* ((win (selected-window))
               (nextdir (car dirs))
               (neighbour-dir (cdr dirs))
               (next-win (windmove-find-other-window nextdir win))
               (neighbour1 (windmove-find-other-window neighbour-dir win))
               (neighbour2 (if next-win (with-selected-window next-win
                                          (windmove-find-other-window neighbour-dir next-win)))))
          ;;(message "win: %s\nnext-win: %s\nneighbour1: %s\nneighbour2:%s" win next-win neighbour1 neighbour2)
          (setq done (and (eq neighbour1 neighbour2)
                          (not (eq (minibuffer-window) next-win))))
          (if done
              (let* ((other-buf (window-buffer next-win)))
                (delete-window next-win)
                (if (eq nextdir 'right)
                    (split-window-vertically)
                  (split-window-horizontally))
                (set-window-buffer (windmove-find-other-window neighbour-dir) other-buf))))))))

(global-set-key (kbd "C-x |") 'window-toggle-split-direction)



;;; avy
(use-package avy :ensure t :pin melpa
  :custom
  (avy-timeout-seconds 0.3)
  (avy-style 'pre)
  :config
  (progn
    (global-set-key (kbd "C-'") 'avy-goto-char-timer)
    (global-set-key (kbd "C-:") 'avy-goto-char-2)
    (global-set-key (kbd "C-c C-j") 'avy-resume)
    (global-set-key (kbd "M-g l") 'avy-goto-line)
    (global-set-key (kbd "M-g f") 'avy-goto-char)
    (global-set-key (kbd "M-g w") 'avy-goto-word-1)
    (global-set-key (kbd "M-g M-j") 'hydra-avy-goto/body)
    (global-set-key (kbd "M-g C-t") 'avy-pop-mark)))


;;; expand-region
(use-package expand-region :ensure t :pin melpa
  :config (global-set-key (kbd "C-=") 'er/expand-region))


;;; Evil, my last resort. (sometimes)

(let ((evil-want-keybinding nil))
  (use-package evil :ensure t :pin melpa))

(setq evil-want-integration t
      evil-want-keybinding t)
(evil-set-undo-system 'undo-tree)

(evil-mode +1)

(setq evil-default-state 'normal) ;;emacs)



(defun toggle-evil-mode ()
  (interactive)
  (evil-mode (if (null evil-state) 1 -1)))


;;; evil-surround
(use-package evil-surround
  :ensure t :pin melpa
  :config
  (global-evil-surround-mode 1))
"
    'Hello world!'

        --> cs'<q> :

    <q>Hello world!</q>



    ysiw] (iw is a text object):

        [Hello] world!



    wrap the entire line in parentheses with yssb or yss):

        ({ Hello } world!)



    Revert to the original text: ds{ds)

        Hello world!

"


;;; or, ansi-term is.
(defun ansi-term-here ()
  (interactive)
  (let* ((sh-bin (getenv "SHELL")))
    (ansi-term sh-bin)))



;;; shell-pop
(use-package shell-pop :ensure t :pin melpa)


;;; eshell-toggle
(use-package eshell-toggle :pin melpa :ensure t)


;;; stardict, sdcv
(use-package sdcv :ensure t :pin melpa
  :config 
  (evil-set-initial-state 'sdcv-mode 'emacs))


;;; realgud
(use-package realgud :ensure t :pin melpa)

;;;
(use-package editorconfig
  :ensure t :pin melpa
  :diminish
  :config
  (editorconfig-mode 1))


;;; yas
(use-package yasnippet :ensure t :pin melpa
  :config (progn
            ;; no more tabs:
            ;; (define-key yas-minor-mode-map [(tab)] nil)
            ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
            ;; desc
            ;; (define-key yas-minor-mode-map (kbd "C-c C-c TAB") 'yas-expand)
            (define-key yas-minor-mode-map (kbd "C-c & d") 'yas-describe-tables)
            ;;
            (yas-global-mode +1)))

(defhydra hydra-yas ()
  "
Yasnippet^^
---------------------------------
_TAB_ expand
_d_ desc
_m_ toggle
_s_ ins
_n_ new
_v_ visit

_SPC_ cancel
"
  ("TAB" yas-expand :exit t)
  ("d" yas-describe-tables :exit t)
  ("m" yas-minor-mode :exit nil)
  ("s" yas-insert-snippet :exit t)
  ("n" yas-new-snippet :exit t)
  ("v" yas-visit-snippet-file :exit t)
  ("SPC" nil)
  )


(use-package yasnippet-snippets :ensure t :pin melpa :after yasnippet)


;;; multiple-cursors
(use-package multiple-cursors :ensure t :pin melpa
  :config (progn (global-set-key (kbd "C-c m c") 'mc/edit-lines)
                 (global-set-key (kbd "C->") 'mc/mark-next-like-this)
                 (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
                 (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))


(defhydra hydra-multiple-cursors (:hint nil)
  "
 Up^^             Down^^           Miscellaneous           % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
------------------------------------------------------------------
 [_p_]   Next     [_n_]   Next     [_l_] Edit lines  [_0_] Insert numbers
 [_P_]   Skip     [_N_]   Skip     [_a_] Mark all    [_A_] Insert letters
 [_M-p_] Unmark   [_M-n_] Unmark   [_s_] Search
 [Click] Cursor at point       [_q_] Quit"
  ("l" mc/edit-lines :exit t)
  ("a" mc/mark-all-like-this :exit t)
  ("n" mc/mark-next-like-this)
  ("N" mc/skip-to-next-like-this)
  ("M-n" mc/unmark-next-like-this)
  ("p" mc/mark-previous-like-this)
  ("P" mc/skip-to-previous-like-this)
  ("M-p" mc/unmark-previous-like-this)
  ("C-n" next-line)
  ("C-p" previous-line)
  ("C-f" forward-char)
  ("C-b" backward-char)    
  ("s" mc/mark-all-in-region-regexp :exit t)
  ("0" mc/insert-numbers :exit t)
  ("A" mc/insert-letters :exit t)
  ("<mouse-1>" mc/add-cursor-on-click)
  ;; Help with click recognition in this hydra
  ("<down-mouse-1>" ignore)
  ("<drag-mouse-1>" ignore)
  ("q" nil))



;;; moonshot
(quelpa '(moonshot :repo "ageldama/moonshot" :fetcher github))
;;(use-package moonshot :ensure t :pin melpa)
(require 'moonshot)

(defhydra hydra-moonshot ()
  "
Moonshot^^
---------------------------------
_x_ run-exe 
_d_ debug 
_c_ run-cmd

_SPC_ cancel
"
  ("x" moonshot-run-executable :exit t)
  ("d" moonshot-run-debugger :exit t)
  ("c" moonshot-run-runner :exit t)
  ("SPC" nil)
  )


;;; Dired
(setq dired-dwim-target t
      wdired-confirm-overwrite t
      wdired-use-interactive-rename t
      )

;;; http://pragmaticemacs.com/emacs/open-a-recent-directory-in-dired-revisited/
;; open recent directory, requires ivy (part of swiper)
;; borrows from http://stackoverflow.com/questions/23328037/in-emacs-how-to-maintain-a-list-of-recent-directories
(require 'recentf)

(defun bjm/ivy-dired-recent-dirs ()
  "Present a list of recently used directories and open the selected one in dired"
  (interactive)
  (recentf-load-list)
  (let ((recent-dirs
         (delete-dups
          (mapcar (lambda (file)
                    (if (file-directory-p file) file (file-name-directory file)))
                  recentf-list))))

    (let ((dir (ivy-read "Directory: "
                         recent-dirs
                         :re-builder #'ivy--regex
                         :sort nil
                         :initial-input nil)))
      (dired dir))))

(global-set-key (kbd "C-x C-d") 'bjm/ivy-dired-recent-dirs)


(defun buffer-path-and-line-col ()
  (interactive)
  (let ((pos (format "%s\t%s\t%s" (or (buffer-file-name) default-directory)
                     (line-number-at-pos) (current-column))))
    (kill-new pos)
    (message "Path (Yanked): %s" pos)))


;;; Files + Dirs
(defhydra files-dirs-hs ()
  "
Files^^            ^Dirs^            
------------------------------------
_f_ open-file           _M-d_ recentf+dired
_r_ recentf             _d_ dired 
_n_ find-by-name        _e_ eshell
_g_ deadgrep            _a_ ansi-term
^ ^                     _._ treemacs
^ ^                     _t_ neotree
^ ^                     ^ ^
_M-s f_ sudo-file       _M-s d_ sudo-dir
_M-l c_ literally-file  _M-l f_ literally-find
^ ^                     ^ ^
_M-w_ copy-path-pos     ^ ^
^ ^                     ^ ^
_SPC_ cancel
"
  ("f" find-file :exit t)
  ("r" counsel-recentf :exit t)
  ("g" deadgrep :exit t)
  ("n" find-name-dired :exit t)
  ("d" dired :exit t)
  ("M-d" bjm/ivy-dired-recent-dirs :exit t)
  ("$" shell-pop :exit t)
  ("e" eshell-toggle :exit t)
  ("a" ansi-term-here :exit t)
  ("." treemacs :exit t)

  ("M-s f" (lambda () (interactive)
             (find-file (s-concat "/sudo:root@localhost:" (buffer-file-name))))
   :exit t)

  ("M-s d" (lambda () (interactive)
             (find-file (s-concat "/sudo:root@localhost:"
                                  (file-name-directory (buffer-file-name)))))
   :exit t)

  ("M-l f" find-file-literally :exit t)
  ("M-l c" (lambda () (interactive) (find-file-literally (buffer-file-name))) :exit t)

  ("M-w" buffer-path-and-line-col :exit t)

  ("t" neotree :exit t)

  ("SPC" nil)
  )


;;; Misc toggles
(defhydra hydra-misc-toggles ()
  "
Toggles:^^
--------------------------
_l_ : display-line-numbers-mode
_s_ : whitespace-mode
_z_ : ZONE
_G_ : my-gc-toggle-timer
_b_ : toggle-battery-saving-mode
_w_ : writeroom-mode
_:_ : toggle-evil-mode

_SPC_ : cancel
"
  ("l" display-line-numbers-mode)
  ("s" global-whitespace-mode)
  ("z" zone)
  ("G" my-gc-toggle-timer)
  ("b" toggle-battery-saving-mode)
  ("w" writeroom-mode)
  (":" toggle-evil-mode)

  ("SPC" nil))


;;; Flycheck + Hydra

(defhydra hydra-flycheck
  (:pre (flycheck-list-errors)
        :post (quit-windows-on "*Flycheck errors*")
        )
  "Errors"
  ("f" flycheck-error-list-set-filter "Filter")
  ("j" flycheck-next-error "Next")
  ("k" flycheck-previous-error "Previous")
  ("gg" flycheck-first-error "First")
  ("G" (progn (goto-char (point-max)) (flycheck-previous-error)) "Last")
  ("?" flycheck-describe-checker "Desc-Chker")
  ("c" flycheck-buffer "ChkBuf")
  ("C" flycheck-compile "Compile")  
  ("s" flycheck-select-checker "Sel-Chker")
  ("v" flycheck-verify-setup "Verify-Setup")
  ("x" flycheck-disable-checker "Disable-Chker")
  ("e" flycheck-explain-error-at-point "Explain-Err")
  ("C-w" flycheck-copy-errors-as-kill "Copy-Err")  
  ("SPC" nil))

;;; Windows/Buffers + Hydraw
(defhydra hydra-windbuf (:hint nil)
  "
^Split^           ^Focus^             ^Buf^                  ^Size^
^^^^^^^^-----------------------------------------------------------------
___: split(v)     _o_: other-win.     _S-<left>_: bmv-l      _=_: balance
_|_: split(h)     _<left>_: wmv-l     _S-<right>_: bmv-r     _+_: enlarge(v)
_%_: toggle-dir.  _<right>_: wmv-r    _S-<up>_: bmv-u        _-_: shrink(v)
_q_: delete-win.  _<up>_: wmv-u       _S-<down>_: bmv-d      _<_: shrink(h)
^ ^               _<down>_: wmv-d     _*_: swap              _>_: enlarge(h)
_f_: new-frame    ^ ^                 _C-<left>_: prev-buf
^ ^               ^ ^                 _C-<right>_: next-buf
_SPC_: EXIT       ^ ^                 _TAB_: ivy-buf
"
  ("_" split-window-below)
  ("|" split-window-right)
  ("%" window-toggle-split-direction)  
  ("q" delete-window)

  ("o" ace-window)    
  ("<left>" windmove-left)
  ("<right>" windmove-right)
  ("<up>" windmove-up)
  ("<down>" windmove-down)

  ("S-<left>" buf-move-left)
  ("S-<right>" buf-move-right)
  ("S-<up>" buf-move-up)
  ("S-<down>" buf-move-down)
  ("C-<left>" previous-buffer)
  ("C-<right>" next-buffer)
  ("TAB" ivy-switch-buffer)
  ("*" ace-swap-window)

  ("f" (make-frame) :exit t)

  ("=" balance-windows)
  ("+" enlarge-window)
  ("-" shrink-window)
  ("<" shrink-window-horizontally)
  (">" enlarge-window-horizontally)
  ("SPC" nil))


;;; string-inflect
(use-package string-inflection  :ensure t :pin melpa)

(defhydra hydra-string-inflection ()
  "
string-inflection:^^
----------------------------------------------------------
_c_: 'fooBar' lower-camelcase
_C_: 'FooBar' capital-camelcase
_p_: 'Foo_Bar' capital-underscore
_k_: 'foo-bar' kebab
_u_: 'foo_bar' underscore
_U_: 'FOO_BAR' upcase
"
  ("c" string-inflection-lower-camelcase :exit t)
  ("C" string-inflection-camelcase :exit t)
  ("p" string-inflection-capital-underscore :exit t)
  ("k" string-inflection-kebab-case :exit t)
  ("u" string-inflection-underscore :exit t)
  ("U" string-inflection-upcase :exit t)
  ("SPC" nil))


(defhydra hydra-avy-goto ()
  "
avy-goto:^^
----------------------------------------------------------
_,_: pop-back
_c_: char-timer
_l_: line
_w_: word-0
_W_: word-1
_q_: (quit)
"
  ("," avy-pop-mark        :exit t)
  ("c" avy-goto-char-timer :exit t)
  ("l" avy-goto-line       :exit t)
  ("w" avy-goto-word-0     :exit t)
  ("W" avy-goto-word-1     :exit t)
  ("q" nil))

;; (evil-global-set-key 'normal "g " 'hydra-avy-goto/body)


;;; snails
;; (quelpa '(snails :repo "manateelazycat/snails" :fetcher github))
;; (setq snails-show-with-frame nil)
;; (add-hook 'snails-mode-hook
;;           (lambda () (evil-mode -1)))




;;;----------------------------------------------------------------------

(use-package general :ensure t :pin melpa)

(defun keysim-regs-marks ()
  (interactive)
  (general--simulate-keys nil "C-x r"))

;; (general-simulate-key "C-x r" :name regs-marks)


;; (use-package with-simulated-input :ensure t :pin melpa)




;;; hydra: global /misc.

(defhydra hydra-misc-fns ()
  "
Misc:^^
--------------------------
_p_ : list-proc
_b_ : bookmarks
_d_ : search sdcv
_s_ : del-trail-ws
_G_ : gc

_SPC_ : cancel
"
  ("p"  counsel-list-processes :exit t)
  ("b"  counsel-bookmark :exit t)
  ("d"  sdcv-search-input :exit t)
  ("s"  delete-trailing-whitespace :exit t)
  ("G"  garbage-collect :exit t)

  ("SPC" nil))


;;; hydra: global /org.

(defun org-open-PLAN ()
  (interactive)
  (find-file "~/P/v3/PLAN.org"))


(defhydra hydra-org ()
  "
Org:^^
--------------------------
_a_ : agenda
_c_ : capture start
_M-c_ : capture open
_p_ : plan
_d_ : diary
_m_ : memo/log (+C-u)

_SPC_ : cancel
"
  ("a"  org-agenda :exit t)
  ("c"  org-capture :exit t)
  ("M-c" org-capture-open :exit t)
  ("p" org-open-PLAN :exit t)
  ("d"  diary/new-or-open-org-file :exit t)
  ("m" diary/new-or-open-memo :exit t)

  ("SPC" nil))


;;; hydra: global /vars.

(defhydra hydra-vars ()
  "
Vars:^^
--------------------------
_d_ : add-dir-local
_f_ : add-file-local
_p_ : add-file-local-prop-line

_SPC_ : cancel
"
  ("d"  add-dir-local-variable :exit t)
  ("f"  add-file-local-variable :exit t)
  ("p"  add-file-local-variable-prop-line :exit t)

  ("SPC" nil))


;;; hydra: global /ext-open.

(defhydra hydra-ext-open ()
  "
Ext-Open:^^
--------------------------
_RET_ : xdg-open-cur-region
_._ : xdg-open-cur-buf
_g_ : google-it

_SPC_ : cancel
"
  ("RET"  xdg-open-current-region :exit t)
  ("."    xdg-open-current-buffer :exit t)
  ("g"    google-it :exit t)

  ("SPC" nil))


;;; hydra: global /root

(defhydra hydra-my-global ()
  ">>> "

  ("f" files-dirs-hs/body "files" :exit t)
  ("$" shell-pop "sh-pop" :exit t)

  ("b"    ibuffer "ibuf" :exit t)
  ("TAB"  ivy-switch-buffer "ivy-buf" :exit t)

  ("?" counsel-descbinds "descbinds" :exit t)

  ("k" counsel-yank-pop "yank-pop" :exit t)
  ("C-k" kill-current-buffer "kill-cur-buf" :exit t)

  ("m" counsel-mark-ring "mark-ring" :exit t)
  ("i" counsel-imenu "imenu" :exit t)

  ("M-q" hydra-misc-toggles/body "toggles" :exit t)
  ("~" hydra-misc-fns/body "misc-fns" :exit t)
  ("o" hydra-org/body "org" :exit t)

  ;; windows
  ("M-w" hydra-windbuf/body "windbuf" :exit t)
  ;; ("M-SPC" other-window "other-win" :exit t)

  ("*" ace-swap-window "ace-swap-win" :exit t)
  ("%" window-toggle-split-direction
   "win-toggle-dir" :exit t)
  ("_" split-window-below "split-win-below" :exit t)
  ("|" split-window-right "split-win-r" :exit t)
  ("q" delete-window "del-win" :exit t)

  ("<left>" windmove-left "windmv-l" :exit t)
  ("<right>" windmove-right "windmv-r" :exit t)
  ("<up>" windmove-up "windmv-up" :exit t)
  ("<down>" windmove-down "windmv-dn" :exit t)

  ("S-<left>" buf-move-left "bufmv-up" :exit t)
  ("S-<right>" buf-move-right "bufmv-dn" :exit t)
  ("S-<up>" buf-move-up "bufmv-up" :exit t)
  ("S-<down>" buf-move-down "bufmv-dn" :exit t)

  ("=" balance-windows "balance-win" :exit t)
  ("+" enlarge-window "enlarge-win" :exit t)
  ("-" shrink-window "shrink-win" :exit t)
  (">" enlarge-window-horizontally "enlarge-win-h" :exit t)
  ("<" shrink-window-horizontally "shrink-win-h" :exit t)

  ;; jumps / registers
  ("r" keysim-regs-marks "regs-marks" :exit t)

  ;; avy
  ("l"   avy-goto-line "goto-line" :exit t)
  ("w"   avy-goto-word-0 "goto-word-0" :exit t)
  ("s" avy-goto-char-timer "goto-char-timer" :exit t)

  ;; projectile
  ("p" projectile-find-file-dwim "proj-find-dwim" :exit t)
  ("P" projectile-commander "prj-cmdr" :exit t)

  ;; magit
  ("g"      magit-status "magit" :exit t)
  ("C-S-g"  omz-ish/gwip "gwip" :exit t)

  ;; 
  ("x" hydra-moonshot/body "moonshot" :exit t)
  ("u" undo-tree-visualize "undo-tree" :exit t)
  ("M-i" hydra-string-inflection/body "str-infl" :exit t)
  ("M-x" hydra-ext-open/body "ext-open" :exit t)
  ("M-v" hydra-vars/body "vars" :exit t)
  ("M-c" hydra-multiple-cursors/body "mcurs" :exit t)

  ;; yas
  ;; ("RET" yas-insert-snippet "yas-ins" :exit t)
  ("M-y" hydra-yas/body "yas" :exit t)

  ;;
  ;;("SPC" nil)
  ;; ("SPC" avy-goto-char-timer "goto-char-timer" :exit t)

  )


;;;

(defvar-local lang-mode-hydra nil)


(defmacro lang-mode-hydra-set (mode-hook hydra-body)
  `(add-hook ,mode-hook
             (lambda () (setq-local lang-mode-hydra
                                    (symbol-function ,hydra-body)))))



(defun do-lang-mode-hydra ()
  (interactive)
  (if lang-mode-hydra
      (call-interactively lang-mode-hydra)
    ;; else
    (message "Null lang-mode-hydra local-var")))


(evil-global-set-key 'normal (kbd "SPC") 'hydra-my-global/body)

(evil-global-set-key 'normal (kbd "M-RET") 'do-lang-mode-hydra)

(global-set-key (kbd "C-x x") 'hydra-my-global/body)

(global-set-key (kbd "C-x c") 'do-lang-mode-hydra)

(global-set-key (kbd "<f8>") 'hydra-my-global/body)

(global-set-key (kbd "<f9>") 'do-lang-mode-hydra)




;;;
(defun my-C-z ()
  (interactive)
  (setq unread-command-events (listify-key-sequence "\C-z")))

;; (global-set-key (kbd "<f5>") 'ace-window)

(if (and (>= emacs-major-version 28)
         (fboundp 'ansi-color-compilation-filter))
    ;; then
    (unless (member 'ansi-color-compilation-filter compilation-filter-hook)
      (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))
  ;; else
  (progn
    (defun colorize-compilation-buffer ()
      (let ((inhibit-read-only t))
        (ansi-color-apply-on-region compilation-filter-start (point))))
    (unless (member 'colorize-compilation-buffer compilation-filter-hook)
      (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))))


(defun recompile-existing-compilation-window ()
  (interactive)
  (let* ((frm+wnd-lst
          (apply #'append
                 (mapcar (lambda (frm)
                           (with-selected-frame frm
                             (mapcar (lambda (wnd) (cons frm wnd))
                                     (window-list))))
                         (visible-frame-list))))
         (comp-frm-wnd (seq-find #'(lambda (frm-wnd)
                                     (with-selected-frame (car frm-wnd)
                                       (with-current-buffer (window-buffer (cdr frm-wnd))
                                         (eq major-mode 'compilation-mode))))
                                 frm+wnd-lst)))
    (if comp-frm-wnd
        (progn (with-selected-frame (car comp-frm-wnd)
                 (with-current-buffer (window-buffer (cdr comp-frm-wnd)) (recompile))))
      ;; else
      (moonshot-run-runner))))

(global-set-key (kbd "<f5>") 'recompile-existing-compilation-window)


(global-set-key (kbd "<f7>") 'toggle-evil-mode)

;; save -> load : use C-M-m to preview jump in `counsel-register'
(global-set-key (kbd "C-x r j") 'counsel-register)
(global-set-key (kbd "C-x r J") 'point-to-register)



;;; Lang-support.
(defvar langsup-loadp-path (expand-file-name "~/.emacs.d/load-p/"))
(defvar langsup-base-path (expand-file-name "~/P/configs/emacs/"))

(defun load-langsup (langsup-name)
  "Specify LANGSUP-NAME as elisp filename to load."
  (interactive "fFile to load:")
  (let ((fn (if (file-exists-p langsup-name)
		langsup-name
	      (format "%s/%s" langsup-base-path langsup-name))))
    (load-file fn)))

(defun load-langsup-or-not (loadp-name langsup-name)
  (let ((loadp-fn (format "%s/%s" langsup-loadp-path loadp-name)))
    (when (f-exists? loadp-fn)
      (load-langsup langsup-name))))

(defun loadp-avail? (loadp-name)
  (let ((loadp-fn (format "%s/%s" langsup-loadp-path loadp-name)))
    (f-exists? loadp-fn)))



(dolist (i '(
             (clojure . "clojure.el")
             (org-more . "org-more.el")
             (protobuf . "proto+grpc.el")
             (groovy . "groovy/groovy.el")
             (js2 . "javascript/js2.el")
             (jsx . "javascript/jsx.el")             
             (web . "web.el")
             (tide . "javascript/tide.el")
             (js+light . "javascript/js+light.el")
             (pug . "javascript/pug.el")
             (vue . "javascript/vue.el")
             (sly . "sly.el")
             (slime . "slime.el")
             (perl5 . "perl5.el")
             (golang . "golang.el")
             (golang-light . "golang-light.el")
             (java-lsp . "lsp.el")
             (golang-lsp . "golang-lsp.el")
             (rust . "rust.el")
             (rust+racer . "rust+racer.el")
             (c++ . "c++.el")
             ;; (c++-light-2021 . "c++-light-2021.el")
             (cmake . "cmake.el")
             (c++-light-2022 . "c++-light-2022.el")
             (c++-ccls . "c++-ccls.el")
             (lsp-cpp-clangd . "lsp-cpp-clangd.el")
             (lsp-cpp-ccls . "lsp-cpp-ccls.el")
             (lsp-rust-rls . "lsp-rust-rls.el")
             (meson . "meson.el")
             (geiser . "geiser.el")
             (auctex . "auctex.el")
             (tcl . "tcl.el")
             (elpy . "python/elpy.el")
             (ruby . "ruby.el")
             (ocaml . "ocaml.el")
             (zig . "zig.el")
             ))
  (load-langsup-or-not (symbol-name (car i)) (cdr i)))



;;;
(evil-set-initial-state 'Info-mode 'emacs)

(when +sys/gui?+
  (setq evil-emacs-state-cursor   `(bar "grey")
        evil-insert-state-cursor  `(bar "#00aa55")
        evil-motion-state-cursor  `(box "blue")
        evil-normal-state-cursor  `(box "dark green")
        evil-replace-state-cursor `(bar "red")
        evil-visual-state-cursor  `(box "orange"))

  (set-face-attribute 'region nil :background "pink"))


;;; Org / Diary.
(load-file (s-concat langsup-base-path "/cal-dt.el"))


;;; xdg-open + region

(defun xdg-open-current-region (start end)
  (interactive "r")
  (shell-command-on-region start end "xargs xdg-open &"))


(defun xdg-open-current-buffer ()
  (interactive)
  (async-shell-command (s-concat "xdg-open "
                                 ;; Dired등의 버퍼는 #'buffer-file-name =NIL 이고, 현재경로만 있으니까.
                                 (or (buffer-file-name) default-directory))))


(defun google-it (start end)
  (interactive "r")
  (let ((q (buffer-substring-no-properties start end)))
    (browse-url (concat "https://google.com/?q="
                        (url-hexify-string q) "!g"))))


;;; Be more evil: took from Spacemacs.
;;; --- vim-unimpaired
(diminish 'evil-collection-unimpaired-mode "")
;; (evil-global-set-key 'normal (kbd "[ t") '(lambda () (interactive (other-frame -1))))
;; (evil-global-set-key 'normal (kbd "] t") '(lambda () (interactive (other-frame +1))))
;; (evil-global-set-key 'normal (kbd "[ w") '(lambda () (interactive (other-window -1))))
;; (evil-global-set-key 'normal (kbd "] w") '(lambda () (interactive (other-window +1))))


;;; Evil-Jump

(defun my-evil-jump-other-win ()
  (interactive)
  (split-window)
  (evil-jump-to-tag))

(evil-global-set-key 'normal (kbd "g D") 'my-evil-jump-other-win)


;;; Evil Peekaboo
(use-package evil-owl :ensure t :pin melpa
  :diminish
  :config
  (setq evil-owl-max-string-length 500)

  (setq evil-owl-header-format      "%s"
        evil-owl-register-format    " %r: %s"
        evil-owl-local-mark-format  " %m: [l: %-5l, c: %-5c] ---- %s"
        evil-owl-global-mark-format " %m: [l: %-5l, c: %-5c] %b ==== %s"
        evil-owl-separator          "\n")

  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)))
  (evil-owl-mode +1))


;;; pacman: protobuf
(let ((path  "/usr/share/emacs/site-lisp/protobuf-mode.el"))
  (when (f-exists? path)
    (load-file path)
    (add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))))


;;; modus
(use-package modus-themes :ensure t :pin melpa
  :config
  (when +sys/gui?+ (load-theme 'modus-operandi 1)))

;;; evil-collection : final retouches
;;;
;; Warning (evil-collection): Make sure to set `evil-want-keybinding' to nil before loading evil or evil-collection.
;; See https://github.com/emacs-evil/evil-collection/issues/60 for more details.
(let ((evil-want-keybinding nil))
  (use-package evil-collection
    :after evil
    :ensure t :pin melpa
    :config
    (progn (evil-collection-init)
           (diminish 'evil-collection-unimpaired-mode ""))
    ))


;;; Uptime, Startup Time
(message "Startup time: %s" (emacs-uptime))



;;; EOF.
