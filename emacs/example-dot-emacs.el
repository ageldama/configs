(setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))
(load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))


;;; Debian Buster:
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(progn
  (setq *ageldama/font-fixed-en* "DejaVu Sans Mono" 
        *ageldama/font-fixed-ko* "나눔고딕코딩" )
  (my-set-fixed-fonts))

(set-face-attribute 'default nil :height 165)
;;; NOTE 105, 85?

;; 너무 느리면 끄자.
(yas-global-mode +1)
;;(yas-global-mode -1)

;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))

;;;EOF.
