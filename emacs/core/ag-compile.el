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


;;; recompile

(defun recompile-showing-compilation-window ()
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
                                         (or (member major-mode '(compilation-mode grep-mode go-test-mode))
                                             )
                                         )))
                                 frm+wnd-lst)))
    (if comp-frm-wnd
        (progn (with-selected-frame (car comp-frm-wnd)
                 (with-current-buffer (window-buffer (cdr comp-frm-wnd)) (recompile))))
      ;; else
      (progn (message "no comile-buffer found")
             (call-interactively 'compile)))))


(global-set-key (kbd "<f5>") #'recompile-showing-compilation-window)

;; C-u <f5> : ...을 compilation buffer에서 직접 실행하길 원해서.
;; (`<esc> g r` 안될 때에)
(define-key compilation-mode-map (kbd "<f5>") #'recompile)
(define-key compilation-minor-mode-map (kbd "<f5>") #'recompile)



(defun compile-this-file ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (compile fn)))




;;;
(provide 'ag-compile)
