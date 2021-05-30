(setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))
(load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))

(progn
  (setq *ageldama/font-fixed-en* "DejaVu Sans Mono" 
        *ageldama/font-fixed-ko* "나눔고딕코딩" )
  (my-set-fixed-fonts))


;;;EOF.
