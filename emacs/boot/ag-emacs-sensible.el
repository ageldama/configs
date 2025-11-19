
(setq inhibit-startup-screen +1)
(prefer-coding-system 'utf-8-unix)

(column-number-mode  +1)
(display-time-mode   -1)
(show-paren-mode     +1)
(transient-mark-mode +1)

(global-auto-revert-mode +1)

(global-whitespace-mode -1)
(setq-default show-trailing-whitespace -1)
(global-visual-line-mode +1)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local show-trailing-whitespace +1)))



(setq truncate-lines nil) ; no h-scroll


;;; no backup files
(setq make-backup-files nil)
(setq version-control   nil)   ; version numbers for backup-files.


;;; no menu/tool/scroll-bars

(defun ag-emacs-sensible-frame-look (&optional frame)
  (if (eq 'x (window-system frame))
      (progn
        (menu-bar-mode   -1)
        (tool-bar-mode   -1)
        (scroll-bar-mode -1))
    (progn
      (menu-bar-mode   -1))))

(push #'ag-emacs-sensible-frame-look
      after-make-frame-functions)

(ag-emacs-sensible-frame-look)


;;; builtin eldoc
(global-eldoc-mode +1)


;;; line numbers
(when (fboundp 'global-display-line-numbers-mode)
  (global-display-line-numbers-mode -1))

(when (version< emacs-version "29.1")
  (require 'linum)
  (global-linum-mode   -1))

(global-hl-line-mode -1)


;;; tabs, indents
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
;;; ONLY affects to REAL <TAB>-chars to display.
;;; (global-set-key "\t" (lambda () (interactive) (insert-char 32 2))) ; [tab] inserts two spaces
(electric-indent-mode +1)
(setq c-basic-offset 2)


;;; menu-bar
(require 'menu-bar)
(require 'tmm)


(defun %menu-bar-open ()
  (interactive)
  (if (window-system) (menu-bar-open)
    (tmm-menubar)))


(global-set-key (kbd "C-`")   #'%menu-bar-open)
(global-set-key (kbd "<f10>") #'%menu-bar-open)


;;; prog-mode
(define-key prog-mode-map (kbd "M-n") 'next-error)
(define-key prog-mode-map (kbd "M-p") 'previous-error)


;;; ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)




;;; "y"/"n", instead of "yes"/"no".

(setq read-answer-short t)
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))



;;; printed s-expressions in the message buffer
(setq eval-expression-print-length nil
      eval-expression-print-level nil)



;;; Smoother UI responsiveness
(setq redisplay-skip-fontification-on-input t)

;; ... By default, Emacs "updates" its ui more often than it needs to
(if (version< emacs-version "30.1")
    (setq idle-update-delay 1.0)
  ;; else: (newer emacs)
  (progn
    (require 'which-func)
    (setq which-func-update-delay 1.0)))


;;; follow symlinks
(setq find-file-visit-truename t
      vc-follow-symlinks t)



;;; help / apropos : to include vars
(setq apropos-do-all t)



;; beeping or blinking

(setq
 visible-bell nil
 ring-bell-function #'ignore
 )


;;; commenting

(setq
 comment-multi-line t
 comment-empty-lines t
 )


;;; tab-bar

;; (global-set-key (kbd "C-x <up>") 'tab-list)
;; (global-set-key (kbd "C-x <down>") 'tab-new)



;;; misc

;; (setq python-indent-guess-indent-offset-verbose nil)

(setq sh-indent-after-continuation 'always)


(setq
 ;; Disable the obsolete practice of end-of-line spacing from the
 ;; typewriter era.
 sentence-end-double-space nil

 ;; According to the POSIX, a line is defined as "a sequence of zero
 ;; or more non-newline characters followed by a terminating newline".
 require-final-newline t
 )


(setq tags-revert-without-query 1)




(when (null confirm-kill-emacs)
  (setf confirm-kill-emacs
        (lambda (&rest args) (interactive)
          (yes-or-no-p "Really quit Emacs?"))))



;;;
(provide 'ag-emacs-sensible)
