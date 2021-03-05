;;; js2-mode.
(use-package add-node-modules-path :ensure t :pin melpa)

(use-package prettier-js        :ensure t :pin melpa)

(defvar *js2-prettier* t)

(defun js2-prettier ()
  (interactive)
  (when (and (or (eq major-mode 'js2-mode)
                 ) *js2-prettier*)
    (prettier-js)))

;; (add-hook 'find-file-hook
;;           (lambda ()
;;             (when (s-starts-with? "/home/jhyun/P/foo"
;;                                   (buffer-file-name))
;;               (setq-local *js2-prettier* nil))))

(use-package js2-mode :ensure t :pin melpa
  :after add-node-modules-path
  :config (progn (eval-after-load 'js2-mode '(add-hook 'js2-mode-hook #'add-node-modules-path))
                 (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
		 (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
                 ;;(add-hook 'js2-mode-hook (lambda () (electric-indent-local-mode -1)))
                 (setq js2-mode-show-parse-errors nil
                       js2-mode-show-strict-warnings nil)))

;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))

;; NPM integration
(use-package npm-mode :ensure t :pin melpa)

;; RUN!
(add-hook 'js2-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'js2-prettier)
            (setq js2-basic-offset 2)
            (set (make-local-variable 'compile-command)
                 (concat "node " (shell-quote-argument buffer-file-name)))))

;; eslint
(use-package eslint-fix :ensure t :pin melpa)

;;; General keymap.
(when (fboundp 'general-create-definer)
  (progn
    ;; js2
    (my-local-leader-def :keymaps 'js2-mode-map
     "f" 'prettier-js
     "r" 'compile
     "n" (general-simulate-key "C-c n" :name npm)
     "C-f" 'eslint-fix
     )
    ;; JSON
    (my-local-leader-def :keymaps 'json-mode-map
     "p" 'jsons-print-path
     "f" 'json-mode-beautify
    )))

;;;
(defconst agelmacs/layer/js2 t)
;;; EOF.
