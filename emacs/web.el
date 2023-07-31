(use-package web-mode :ensure t :pin melpa)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))

(setq web-mode-engines-alist
      '(("blade"  . "\\.blade\\.")
        ("django" . "\\.jj2.html\\'")))
