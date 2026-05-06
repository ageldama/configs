;;; compile & recompile

(require 'compile)


;;;

(setq
 compilation-always-kill t
 compilation-ask-about-save t
 compilation-scroll-output 'first-error
 )


;;; colorize-compilation-buffer

(if (and (>= emacs-major-version 28)
         ;; (require 'ansi-color-compilation-filter))
         (require 'ansi-color nil t))
    ;; then
    (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  ;; else
  (progn
    (defun colorize-compilation-buffer ()
      (let ((inhibit-read-only t))
        (ansi-color-apply-on-region compilation-filter-start (point))))
    (unless (member 'colorize-compilation-buffer compilation-filter-hook)
      (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))))



;; [2026-05-06 Wed 16:59] 뭔가 버퍼이름을 바꾸면 `recompile'시 이상한 일이 벌어진다. 냅두자.
;; 그냥 손으로 `rename-buffer' (C-x x r) 하자.
;;
;; (setq compilation-buffer-name-function 
;;       (lambda (mode)
;;         (message "*%s (%s)*"
;;                  compile-command default-directory)))





(setq compilation-scroll-output t)






;;; recompile

;; C-u <f5> : ...을 compilation buffer에서 직접 실행하길 원해서.
;; (`<esc> g r` 안될 때에)
;; (define-key compilation-mode-map (kbd "<f5>") #'recompile)
;; (define-key compilation-minor-mode-map (kbd "<f5>") #'recompile)



(defun compile-this-file ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (compile (shell-quote-argument fn))))




;;;
(provide 'ag-compile)
