
(setq inhibit-startup-screen +1)
(prefer-coding-system 'utf-8-unix)

(column-number-mode  +1)
(display-time-mode   -1)
(show-paren-mode     +1)
(transient-mark-mode +1)

(global-auto-revert-mode +1)
(global-whitespace-mode -1)
(setq-default show-trailing-whitespace +1)



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


;;;
(global-visual-line-mode +1)


;;; builtin eldoc
(global-eldoc-mode -1)




;;; GUI fonts

;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/

(defun ag-set-fixed-fonts (&optional en-fn ko-fn)
  (interactive)
  (let ((en-fn* (or en-fn "DejaVu Sans Mono"))
        (ko-fn* (or ko-fn "NanumGothicCoding")))
    ;; default Latin font (e.g. Consolas)
    ;; but I use Monaco
    (set-frame-font en-fn* t)
    (set-face-attribute 'default nil :family en-fn*)
    ;; default font size (point * 10)
    ;; WARNING!  Depending on the default font,
    ;; if the size is not supported very well, the frame will be clipped
    ;; so that the beginning of the buffer may not be visible correctly.
    (set-face-attribute 'default nil :height 130)
    ;; use specific font for Korean charset.
    ;; if you want to use different font size for specific charset,
    ;; add :size POINT-SIZE in the font-spec.
    (set-fontset-font t 'hangul (font-spec :name ko-fn*))))


(when (and t window-system)
  (cond
   ;;
   ((member system-type
            '(berkeley-unix gnu/linux darwin))
    (ag-set-fixed-fonts))
   ;;
   ((string-equal system-type "windows-nt")
    (set-face-attribute 'default nil :font "Consolas-11"))
   (t :unknown)))




;;; line numbers
(if (fboundp 'global-display-line-numbers-mode)
    (global-display-line-numbers-mode -1)
  ;; else
  (global-linum-mode   -1))
(global-hl-line-mode -1)


;;; hippie-expand
(defadvice hippie-expand (around hippie-expand-case-fold)
  "Try to do case-sensitive matching (not effective with all functions)."
  (let ((case-fold-search nil))
    ad-do-it))

(ad-activate 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill
        try-complete-file-name-partially try-complete-file-name
        try-expand-all-abbrevs try-expand-list try-expand-line
        try-complete-lisp-symbol-partially try-complete-lisp-symbol))

(global-set-key "\M-/" 'hippie-expand)


;;; menu-bar
(global-set-key (kbd "M-`")       'menu-bar-open)
(global-set-key (kbd "<f10>")       'menu-bar-open)



;;; tabs, indents
(setq-default indent-tabs-mode nil)
(setq tab-width nil)
;;; ONLY affects to REAL <TAB>-chars to display.
;;; (global-set-key "\t" (lambda () (interactive) (insert-char 32 2))) ; [tab] inserts two spaces
(electric-indent-mode +1)
(setq c-basic-offset 2)





;;;
(provide 'ag-emacs-sensible)
