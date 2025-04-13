;; TODO
(use-package consult    :ensure t :pin melpa
  :after projectile
  :bind (("C-x r x" . consult-register)
         ("C-x r b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complet-command
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)
         ("M-#" . consult-register)
         ;;("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ("M-g o" . consult-outline) 
         ("M-g h" . consult-org-heading)
         ("M-g a" . consult-org-agenda)
         ("M-g m" . consult-mark)
         ("C-x b" . consult-buffer)
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-project-imenu)
         ("M-g e" . consult-error)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s L" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         ("M-g l" . consult-line)    
         ("M-s m" . consult-multi-occur)
         ("C-x c o" . consult-multi-occur)
         ("C-x c SPC" . consult-mark)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line))
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  :config
  (setq consult-project-root-function #'projectile-project-root)
  (setq consult-narrow-key "<"))
