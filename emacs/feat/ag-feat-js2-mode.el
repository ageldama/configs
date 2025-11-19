

(use-package js2-mode :ensure t :pin melpa
  :after add-node-modules-path
  :config
  (add-hook 'js2-mode-hook
            (lambda ()
              (when (fboundp 'add-node-modules-path)
                (add-node-modules-path))))
  (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.cjs" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.mjs" . js2-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  ;;(add-hook 'js2-mode-hook (lambda () (electric-indent-local-mode -1)))
  (setq js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil)
  )


(when (fboundp 'defhydra)
  (eval '(defhydra hydra-lang-js2 ()
           "js2"

           ;; ("f" prettier-js "prettier" :exit t)
           ("r" compile "compile" :exit t)
           ;; ("C-f" eslint-fix "eslint-fix" :exit t)

           ("SPC" nil)))

  (require 'ag-lang-mode)
  (lang-mode-hydra-set 'js2-mode-hook 'hydra-lang-js2/body))




(provide 'ag-feat-js2-mode)
