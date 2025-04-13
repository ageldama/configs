
(setq inhibit-startup-screen +1)
(prefer-coding-system 'utf-8-unix)

(column-number-mode  +1)
(display-time-mode   -1)
(show-paren-mode     +1)
(transient-mark-mode +1)

(global-auto-revert-mode +1)

(global-whitespace-mode -1)
(setq-default show-trailing-whitespace +1)
(global-visual-line-mode +1)


;;; no backup files
(setq make-backup-files nil)
(setq version-control   nil)   ; version numbers for backup-files.


;;; no menu/tool/scroll-bars
(if window-system
    (progn
      (menu-bar-mode   -1)
      (tool-bar-mode   -1)
      (scroll-bar-mode -1))
  (progn
    (menu-bar-mode   -1)))


;;; builtin eldoc
(global-eldoc-mode +1)


;;; line numbers
(if (fboundp 'global-display-line-numbers-mode)
    (global-display-line-numbers-mode -1)
  ;; else
  (global-linum-mode   -1))
(global-hl-line-mode -1)


;;; tabs, indents
(setq-default indent-tabs-mode nil)
(setq tab-width nil)
;;; ONLY affects to REAL <TAB>-chars to display.
;;; (global-set-key "\t" (lambda () (interactive) (insert-char 32 2))) ; [tab] inserts two spaces
(electric-indent-mode +1)
(setq c-basic-offset 2)


;;; menu-bar
(global-set-key (kbd "M-`")       'menu-bar-open)
(global-set-key (kbd "<f10>")       'menu-bar-open)


;;; prog-mode
(define-key prog-mode-map (kbd "M-n") 'next-error)
(define-key prog-mode-map (kbd "M-p") 'previous-error)



;;;
(provide 'ag-emacs-sensible)
