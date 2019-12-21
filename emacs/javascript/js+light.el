(use-package add-node-modules-path :ensure t :pin melpa)

(require 'flycheck)
(add-hook 'js-mode-hook #'add-node-modules-path)
;;(flycheck-add-mode 'javascript-eslint 'js-mode)
;;(add-hook 'js-mode-hook 'flycheck-mode)




(use-package prettier-js :ensure t :pin melpa)


(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
