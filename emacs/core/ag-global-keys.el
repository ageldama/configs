(require 'ag-hydra--main)
(require 'ag-lang-mode)
(require 'ag-reinit)


(ag-reinit/add-as-interactive
 (when (fboundp 'evil-global-set-key)
   (evil-global-set-key 'normal (kbd "SPC") 'hydra-mini/body)
   (evil-global-set-key 'normal (kbd "\\") 'do-lang-mode-hydra))

 (global-set-key (kbd "C-c SPC") 'hydra-mini/body)
 (global-set-key (kbd "C-c \\") 'do-lang-mode-hydra)

 ;; (global-set-key (kbd "C-c 8") 'hydra-mini/body)
 ;; (global-set-key (kbd "C-c 9") 'do-lang-mode-hydra)
 ;;
 ;; (global-set-key (kbd "<f8>") 'hydra-mini/body)
 ;; (global-set-key (kbd "<f9>") 'do-lang-mode-hydra)

 (global-set-key (kbd "M-s g g") 'grep)
 (global-set-key (kbd "M-s g r") 'rgrep)
 (global-set-key (kbd "M-s g l") 'lgrep)
 (global-set-key (kbd "M-s g f") 'grep-find)
 ;; (global-set-key (kbd "M-s g r") 'rg)
 ;; (global-set-key (kbd "M-s g d") 'deadgrep)
 )




;;;
(provide 'ag-global-keys)
