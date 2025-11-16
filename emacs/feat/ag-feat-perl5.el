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

(require 'perltidy)
;; (let ((base-fn  (concat load-layer-base-path "perl/perltidy")))
;;   (if (file-exists-p (concat base-fn ".elc"))
;;       (load base-fn)
;;     (byte-compile-file fn t)))


(require 'cperl-mode)

(when (boundp 'apheleia-mode-alist)
  (add-to-list 'apheleia-mode-alist '(cperl-mode . perltidy)))

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
;; (define-key cperl-mode-map (kbd "C-c e") 'run-perl-prove)
;; (define-key cperl-mode-map (kbd "C-c r") 'cperl-db)
;; (add-hook 'cperl-mode-hook (lambda () (local-set-key (kbd "C-c t") 'perltidy-dwim)))

(when (fboundp 'defhydra)
  (require 'cperl-mode)

  (eval '(progn
           (defhydra hydra-lang-cperl ()
           "perl5"

           ("d" cperl-db "dbg" :exit t)
           ("r" run-perl-prog "run" :exit t)
           ("t" run-perl-prove "prove" :exit t)
           ("?" cperl-perldoc-at-point "cperl-doc" :exit t)
           ("m" cperl-build-manpage "cperl-build-man" :exit t)
           ("f" perltidy-dwim "perltidy" :exit t)

           ("SPC" nil)))

  ;; FIXME (require 'ag-lang-mode)
  ;; FIXME (lang-mode-hydra-set 'cperl-mode-hook 'hydra-lang-cperl/body)

  ))







(provide 'ag-feat-perl5)
