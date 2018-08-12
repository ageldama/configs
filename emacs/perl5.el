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
(setq cperl-indent-level 4
      cperl-close-paren-offset -4
      cperl-continued-statement-offset 4
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t)

;;; helm-perldoc
(use-package helm-perldoc :ensure t :pin melpa
  :config (helm-perldoc:setup))

;;;
(add-hook 'cperl-mode-hook
 	  (lambda () (local-set-key (kbd "C-c t") 'perltidy-dwim)))

(load (concat load-layer-base-path "perl/perltidy"))
;; (let ((base-fn  (concat load-layer-base-path "perl/perltidy")))
;;   (if (file-exists-p (concat base-fn ".elc"))
;;       (load base-fn)
;;     (byte-compile-file fn t)))


(require 'cperl-mode)
(define-key cperl-mode-map (kbd "C-c r") 'cperl-db)
(define-key cperl-mode-map (kbd "C-c d") 'helm-perldoc)


;;;
(require 'f)

(defun run-perl-prove ()
  "from https://github.com/hitode909/emacs-config/blob/master/inits/50-perl-config.el#L11"
  (interactive)
  (let* ((dir (vc-git-root default-directory))
         (inc-opt (if (f-dir-p (concat dir "/lib")) "-Ilib" ""))
         (fn (buffer-file-name (current-buffer))))
    (compile
     (read-from-minibuffer
      "CMD: "
      (format "cd %s; carton exec prove --nocolor %s %s" dir fn inc-opt)))))

(define-key cperl-mode-map (kbd "C-c e") 'run-perl-prove)


;;; EOF.
