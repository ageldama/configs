
(eval '(let ((evil-want-keybinding nil))
         (use-package evil-collection
           ;; :after evil
           :ensure t :pin melpa
           :config
           (progn
             ;; (setf evil-want-keybinding nil)
             (evil-collection-init)
             (diminish 'evil-collection-unimpaired-mode))
           )
         ))


(provide 'ag-feat-evil-collection)
