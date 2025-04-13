(require 'ag-hydra--main)
(require 'ag-lang-mode)


(evil-global-set-key 'normal (kbd "SPC") 'hydra-mini/body)
(evil-global-set-key 'normal (kbd "\\") 'do-lang-mode-hydra)

(global-set-key (kbd "C-c 8") 'hydra-mini/body)
(global-set-key (kbd "C-c 9") 'do-lang-mode-hydra)

(global-set-key (kbd "<f8>") 'hydra-mini/body)
(global-set-key (kbd "<f9>") 'do-lang-mode-hydra)



;;;
(provide 'ag-global-keys)
