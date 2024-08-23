(use-package nasm-mode :ensure t :pin melpa)

(require 'nasm-mode)
(add-to-list 'auto-mode-alist '("\\.\\(asm\\|s\\)$" . nasm-mode))
