;;; Evil Peekaboo
(use-package evil-owl :ensure t :pin melpa
  :diminish
  :config
  (setq evil-owl-max-string-length 500)

  (setq evil-owl-header-format      "%s"
        evil-owl-register-format    " %r: %s"
        evil-owl-local-mark-format  " %m: [l: %-5l, c: %-5c] ---- %s"
        evil-owl-global-mark-format " %m: [l: %-5l, c: %-5c] %b ==== %s"
        evil-owl-separator          "\n")

  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)))
  (evil-owl-mode +1))
