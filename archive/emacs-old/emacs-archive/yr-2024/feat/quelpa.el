(use-package quelpa :ensure t :pin melpa
  ;; big startup/init speed boosts:
  :config (setq quelpa-checkout-melpa-p  nil ; don't use it
                quelpa-update-melpa-p    nil ; and don't even update it
                ))

;;; NOTE do this manually:
;; (quelpa-checkout-melpa)
