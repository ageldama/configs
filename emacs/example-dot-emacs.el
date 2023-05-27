(setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))

;; TODO (load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))

(load-file (expand-file-name "~/P/configs/emacs/dot-mini-emacs-2023"))


;;; Loads for mini-emacs:
(let ((l '(
           "company.el"           
           "deadgrep.el"
           "editorconfig.el"
           "eldoc.el"
           "flycheck.el"          
           "hl-todo.el"           
           "magit.el"             
           "markdown-mode.el"
           "moonshot.el" 
           "multiple-cursors.el"
           "plantuml.el"          
           "quelpa.el"         
           "readlgud.el"
           "string-inflection.el"
           "undo-tree.el"
           "unfill.el"      
           "vimish-fold.el"                  
           "which-key.el"
           "yas.el"
           )))
  (dolist (i l)
    (load-file (expand-file-name
                (s-concat "~/P/configs/emacs/theo/" i)))))



;;; Debian Buster:
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(when window-system
  (progn
    (setq *ageldama/font-fixed-en* "DejaVu Sans Mono" 
          *ageldama/font-fixed-ko* "나눔고딕코딩" )
    (my-set-fixed-fonts))

  (set-face-attribute 'default nil :height 125)
  ;;; NOTE 105, 85?

  ;; (load-theme 'modus-vivendi t)
  (load-theme 'modus-operandi-tinted t)
  )


;; 너무 느리면 끄자.
(when (fboundp 'yas-global-mode)
  (yas-global-mode +1)
  ;; (yas-global-mode -1)
  )

;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))


(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))


;; (dolist (cmd '(
;;                "cd %d; rubocop -A"
;;                ))
;;   (cl-pushnew cmd moonshot-runners-preset :test #'string=))

;;;EOF.
