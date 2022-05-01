;; use cperl-mode instead of perl-mode
(setq auto-mode-alist (rassq-delete-all 'perl-mode auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.\\(p\\([lm]\\)\\)\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))
(add-to-list 'auto-mode-alist '("cpanfile$" . cperl-mode))

(setq interpreter-mode-alist (rassq-delete-all 'perl-mode interpreter-mode-alist))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;;; indents
(setq
    ;; cperl-indent-level 2
    ;;   cperl-close-paren-offset -2
    ;;   cperl-continued-statement-offset 2
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t)

(load (concat langsup-base-path "perl/perltidy"))
;; (let ((base-fn  (concat load-layer-base-path "perl/perltidy")))
;;   (if (file-exists-p (concat base-fn ".elc"))
;;       (load base-fn)
;;     (byte-compile-file fn t)))


(require 'cperl-mode)


;;;
(require 'f)
(require 'tramp)

(defun run-perl-prove ()
  (interactive)
  (let* ((dir (vc-git-root default-directory))
         ;;(inc-opt (if (f-dir-p (concat dir "/lib")) "-Ilib" ""))
         (fn (buffer-file-name (current-buffer))))
    (compile
     (read-from-minibuffer
      "CMD: "
      (format "cd %s; prove --nocolor %s" dir fn)))))

(defun run-perl-prog ()
  (interactive)
  (compile
   (read-from-minibuffer "CMD: "
                         (concat "perl " (buffer-file-name)))))

;;;
(define-key cperl-mode-map (kbd "C-c e") 'run-perl-prove)
(define-key cperl-mode-map (kbd "C-c r") 'cperl-db)
(add-hook 'cperl-mode-hook
 	  (lambda () (local-set-key (kbd "C-c t") 'perltidy-dwim)))

(when (fboundp 'general-create-definer)
  ;; cperl
  (my-local-leader-def :keymaps 'cperl-mode-map
    "d" 'cperl-db
    "r" 'run-perl-prog
    "t" 'run-perl-prove
    "?" 'cperl-perldoc-at-point
    "m" 'cperl-build-manpage
    "f" 'perltidy-dwim
    ))


;;; EOF.
