
(use-package avy :ensure t :pin melpa
  :custom
  (avy-timeout-seconds 0.3)
  (avy-style 'pre)

  :config
  (progn
    ;; (global-set-key (kbd "C-'") 'avy-goto-char-timer)
    ;; (global-set-key (kbd "C-\"") 'avy-goto-word-1)
    ;; (global-set-key (kbd "C-:") 'avy-goto-line)
    (global-set-key (kbd "M-g SPC") 'avy-goto-char-timer)
    ;; (global-set-key (kbd "M-g M-g") 'goto-line)
    (global-set-key (kbd "M-g l") 'avy-goto-line)
    (global-set-key (kbd "M-g f") 'avy-goto-char)
    (global-set-key (kbd "M-g w") 'avy-goto-word-1)
    (global-set-key (kbd "M-g W") 'avy-goto-word-0)
    ;; (global-set-key (kbd "M-g j") 'hydra-avy-goto/body)
    (global-set-key (kbd "M-g M-g") 'avy-resume)
    (global-set-key (kbd "M-g ,") 'avy-pop-mark)

    (ag-reinit/add-as-interactive
     (when (and (fboundp 'evil-global-set-key)
                (fboundp 'avy-goto-char-timer))
       (evil-global-set-key 'normal "s" 'avy-goto-char-timer)))
    ))


;;;
(provide 'ag-feat-avy)
