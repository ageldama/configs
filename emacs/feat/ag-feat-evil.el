
(let ((evil-want-keybinding nil))
  (use-package evil :ensure t :pin melpa))

(setq evil-want-integration t
      evil-want-keybinding t)

(evil-set-undo-system 'undo-tree)

;; (evil-mode +1)

(setq evil-default-state 'normal) ;;emacs)




(defun toggle-evil-mode ()
  (interactive)
  (evil-mode (if (null evil-state) 1 -1)))


(defun my-evil-jump-other-win ()
  (interactive)
  (split-window)
  (evil-jump-to-tag))



;; (global-set-key (kbd "<f7>") 'toggle-evil-mode)

(evil-global-set-key 'normal (kbd "g D") 'my-evil-jump-other-win)


;;;
(provide 'ag-feat-evil)
