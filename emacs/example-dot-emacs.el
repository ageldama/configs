(setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))
(load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))


;;; Debian Buster:
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(progn
  (setq *ageldama/font-fixed-en* "DejaVu Sans Mono" 
        *ageldama/font-fixed-ko* "나눔고딕코딩" )
  (my-set-fixed-fonts))

;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))

;;;EOF.
