(use-package add-node-modules-path :ensure t :pin melpa)

(defun remove-electric-indent-mode ()
  (electric-indent-local-mode -1))

(use-package vue-mode :ensure t :pin melpa
  :after add-node-modules-path
  :config
  (require 'flycheck)
  ;;(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
  (eval-after-load 'vue-mode '(add-hook 'vue-mode-hook #'add-node-modules-path))
  ;;(eval-after-load 'js-mode '(add-hook 'js-mode-hook #'add-node-modules-path))
  (flycheck-add-mode 'javascript-eslint 'vue-mode)
  (flycheck-add-mode 'javascript-eslint 'vue-html-mode)
  (flycheck-add-mode 'javascript-eslint 'css-mode)
  (add-hook 'vue-mode-hook 'flycheck-mode)
  (add-hook 'vue-mode-hook
            (lambda () (local-set-key (kbd "TAB")
                                      'indent-relative-first-indent-point)))
  (add-hook 'vue-mode-hook 'remove-electric-indent-mode))


(add-hook 'vue-mode-hook 'prettier-js-mode)
