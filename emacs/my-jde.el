
;;; jde
(defun my-jde-mode-hook () 
    "Hook for running Java file..."
    (message "Loading my-java-hook...")
    (define-key c-mode-base-map "\C-ca" 'jde-javadoc-generate-javadoc-template)    
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)      
    (c-set-offset 'substatement-open 0)    
    (c-set-offset 'statement-case-open 0)    
    (c-set-offset 'case-label '+)    
    (fset 'my-javadoc-code
        [?< ?c ?o ?d ?e ?>?< ?/ ?c ?o ?d ?e ?> left left left left left left left])    
    (define-key c-mode-base-map "\C-cx" 'my-javadoc-code)    
    (abbrev-mode t)    
    (setq c-comment-continuation-stars "* "
        tab-width 4 
        indent-tabs-mode nil
        tempo-interactive t
        c-basic-offset 4)
    (message "my-jde-mode-hook function executed"))
(add-hook 'jde-mode-hook 'my-jde-mode-hook)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.32")
 '(jde-ant-enable-find t)
 '(jde-ant-home "$ANT_HOME")
 '(jde-auto-parse-max-buffer-size 0)
 '(jde-build-function (quote (jde-ant-build)))
 '(jde-complete-function (quote jde-complete-minibuf)))


;;;EOF