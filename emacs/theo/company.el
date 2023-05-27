;;; company.
(use-package company :ensure t :pin melpa
  :diminish company-mode
  :config (progn (require 'company)
                 (setq company-idle-delay 0.2)
		 (global-company-mode +1)
                 ;; (global-set-key (kbd "C-TAB") 'company-complete)
		 ;; (global-set-key (kbd "C-c \\") 'company-complete)
                 ;; (global-set-key (kbd "C-c \\") 'counsel-company)
		 (define-key company-active-map (kbd "RET") 'company-complete-selection)
		 (define-key company-active-map (kbd "<prior>") 'company-previous-page)
		 (define-key company-active-map (kbd "<next>") 'company-next-page)

                 (let ((map company-active-map))
                   (define-key map (kbd "<tab>") 'company-complete-common-or-cycle))
                 (let ((map company-active-map))
                   (define-key map (kbd "<backtab>") 'company-select-previous))

                 (with-eval-after-load 'company
                   (define-key company-active-map (kbd "C-M-i") #'company-complete)
                   (define-key company-active-map (kbd "C-SPC") #'company-complete-selection)
                   (define-key company-active-map (kbd "<C-return>") #'company-complete-selection))

                 ;;
		 (setq company-tooltip-align-annotations t)
		 (add-hook 'after-init-hook 'global-company-mode)))

(defmacro bind-company-local-key (hook key)
  `(add-hook ,hook
             (lambda () (local-set-key ,key 'company-capf))))

(bind-company-local-key 'prog-mode-hook (kbd "C-c TAB"))
(bind-company-local-key 'text-mode-hook (kbd "C-c TAB"))
