(use-package autodisass-java-bytecode
  :ensure t :pin melpa)

(use-package google-c-style
  :ensure t :pin melpa
  :commands
  (google-set-c-style))

(use-package smartparens :ensure t :pin melpa)

(use-package realgud :ensure t :pin melpa)

(use-package meghanada
  :ensure t :pin melpa
  :defer t
  :init
  (add-hook 'java-mode-hook
            (lambda ()
              (google-set-c-style)
              (google-make-newline-indent)
              (meghanada-mode t)
              (smartparens-mode t)
              (rainbow-delimiters-mode t)
              (highlight-symbol-mode t)
              (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))

  :config
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2)
  (setq meghanada-server-remote-debug t)
  (setq meghanada-javac-xlint "-Xlint:all,-processing")
  :bind
  (:map meghanada-mode-map
        ("C-S-t" . meghanada-switch-testcase)
        ("M-RET" . meghanada-local-variable)
        ("C-M-." . helm-imenu)
        ("M-r" . meghanada-reference)
        ("M-t" . meghanada-typeinfo)))


(when (fboundp 'general-create-definer)
  (my-local-leader-def :keymaps 'meghanada-mode-map
    "s" '(:ignore t :which-key "server")
    "s s" 'meghanada-server-start
    "s r" 'meghanada-restart
    "s k" 'meghanada-server-kill
    "s C" 'meghanada-client-direct-connect
    "s c" 'meghanada-client-connect
    "s d" ' meghanada-client-disconnect
    "s p" 'meghanada-client-ping
    "s K" 'meghanada-clear-cache
    ;;
    "c" '(:ignore t :which-key "compile")
    "c c" 'meghanada-compile-file
    "c b" 'meghanada-project-compile
    ;;
    "r" '(:ignore t :which-key "run")
    "r m" 'meghanada-exec-main
    "r j" 'meghanada-run-junit-class
    "r J" 'meghanada-run-junit-test-case
    "r /" 'meghanada-switch-testcase
    "r t" 'meghanada-run-task   
    ;;
    "d" '(:ignore t :which-key "debug")
    "d m" 'meghanada-debug-main
    "d j" 'meghanada-debug-junit-class
    "d J" 'meghanada-debug-junit-test-case
    ;;
    "k" '(:ignore t :which-key "code")
    "k i" 'meghanada-import-at-point    
    "k I" 'meghanada-import-all
    "k o" 'meghanada-optimize-import
    "k v" 'meghanada-local-variable    
    "k !" 'meghanada-project-show   
    "k ." 'meghanada-reference
    "k s" 'meghanada-search-everywhere
    "k S" 'meghanada-search-everywhere-ex
    "k ?" 'meghanada-typeinfo  
    "k f" 'meghanada-code-beautify
    ))


;;; EOF.
