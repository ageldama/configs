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

;;; keymap.
(defhydra hydra-lang-js2
  "js2"
  
  ("f" prettier-js "prettier" :exit t)
  ("r" compile "compile" :exit t)
  ("C-f" eslint-fix "eslint-fix" :exit t)

  ("SPC" nil))

(defhydra hydra-lang-json
  "json"
  ("p" jsons-print-path "print-path" :exit t)
  ("f" json-mode-beautify "beautify" :exit t)

  ("SPC" nil))
  
(lang-mode-hydra-set 'js2-mode-hook 'hydra-lang-js2/body)

(lang-mode-hydra-set 'json-mode-hook 'hydra-lang-json/body)

;;;
(defconst agelmacs/layer/js2 t)
;;; EOF.
