(use-package web-mode :ensure t :pin melpa)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(unless (fboundp 'php-mode)
  (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode)))

(setq web-mode-engines-alist
      '(("blade"  . "\\.blade\\.")
        ("django" . "\\.jj2.html\\'")))

(add-to-list 'auto-mode-alist '("\\.mjs?\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.cjs?\\'" . js-mode))


(add-hook 'html-mode-hook 'web-mode)
