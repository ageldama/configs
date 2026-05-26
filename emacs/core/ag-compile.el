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


(when (boundp 'compilation-max-output-line-length)
  (setq compilation-max-output-line-length nil))


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




(defun chmod+x-and-compile-this-file ()
  (interactive)
  (chmod+x-this-file)
  (compile-this-file))



;;; C-<f5>



(defvar *command-filter-list*
  (list "db$" "^realgud:" "^gud-")
  "리스트의 각 요소는 `string-match'-pattern 문자열이거나,
 심볼이름 문자열에 대한 predicate이거나.")



(require 'cl)



(defun command-filtered-list ()
  (let (commands)
    (mapatoms (lambda (s)
                (when (commandp s)
                  (push s commands))))
    ;;
    (cl-loop for cmd in commands
             as cmd-name = (symbol-name cmd)
             append (cl-loop for filter in *command-filter-list*
                             when (and (stringp filter)
                                       (string-match filter
                                                     cmd-name))
                             collect cmd
                             end
                             when (and (functionp filter)
                                       (funcall filter
                                                cmd-name))
                             collect cmd
                             end))))


(defun my-run-debugger ()
  (interactive)
  (let ((cmd (completing-read "Which command? "
                              (command-filtered-list))))
    ;; (message "%s / %s" (type-of cmd) (pp-to-string cmd))
    (call-interactively (intern cmd))))











;;;
(provide 'ag-compile)
