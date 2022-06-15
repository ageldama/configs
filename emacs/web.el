(use-package web-mode :ensure t :pin melpa)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("django" . "\\.jj2.html\\'")))
