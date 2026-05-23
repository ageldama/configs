(use-package add-node-modules-path :ensure t :pin melpa)

(setq js-indent-level 2)

;;; https://gist.github.com/CodyReichert/9dbc8bd2a104780b64891d8736682cea
(use-package web-mode :ensure t :pin melpa)
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode)) ;; auto-enable for .js/.jsx files
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(javascript-jshint json-jsonlist)))

(flycheck-add-mode 'javascript-eslint 'web-mode)

(defun web-mode-init-prettier-hook ()
  (add-node-modules-path)
  (prettier-js-mode))

(add-hook 'web-mode-hook  'web-mode-init-prettier-hook)




(require 'flycheck)
(add-hook 'js-mode-hook #'add-node-modules-path)
;;(flycheck-add-mode 'javascript-eslint 'js-mode)
;;(add-hook 'js-mode-hook 'flycheck-mode)




(use-package prettier-js :ensure t :pin melpa)


(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)


(use-package json-mode :ensure t :pin melpa)
