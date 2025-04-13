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


;;;
(provide 'ag-hippie-expand)
