;;; Evil
(use-package evil :ensure t :pin melpa
  :init (setq evil-want-integration nil)
  :config (evil-mode -1))

(defun toggle-evil-mode ()
  (interactive)
  (evil-mode (if (null evil-state) 1 -1)))

(global-set-key (kbd "C-z") 'toggle-evil-mode)


(use-package hlinum :ensure t :pin melpa :config (hlinum-deactivate))

(use-package vi-tilde-fringe :ensure t :pin melpa
  :config (global-vi-tilde-fringe-mode -1))

(defun my-evil-visual-state-entry-hook ()
  (when (and hl-line-mode (eq evil-visual-selection 'block))
    (hl-line-mode -1)))
(add-hook 'evil-visual-state-entry-hook 'my-evil-visual-state-entry-hook)
(defun my-evil-visual-state-exit-hook ()
  (when (and (not hl-line-mode) (eq evil-visual-selection 'block))
    (hl-line-mode)))
(add-hook 'evil-visual-state-exit-hook 'my-evil-visual-state-exit-hook)

(use-package evil-collection :ensure t :after evil
  :config (evil-collection-init))

(use-package evil-easymotion :ensure t :pin melpa
  :config (evilem-default-keybindings "SPC"))

(use-package evil-goggles :ensure t :pin melpa
  :diminish 'evil-goggles-mode
  :config (when yes-frills (evil-goggles-mode -1)))

(use-package evil-vimish-fold :ensure t :pin melpa
  :diminish 'evil-vimish-fold-mode
  :config (evil-vimish-fold-mode 1))

(use-package evil-matchit :ensure t :pin melpa
  :config (global-evil-matchit-mode +1))

(use-package evil-lion :ensure t :pin melpa
  :config (evil-lion-mode +1))

;;; Evil, no thanks here:
(defun evil-nothanks-mode (mode)
  "Apply evil-set-initial-state-mode as 'EMACS for given MODE is available."
  (when (fboundp mode)
    (evil-set-initial-state mode 'emacs)))

(when (fboundp 'evil-set-initial-state)
  (dolist (mode '(dired-mode
		  helm-ag-mode
		  helm-moccur-mode
		  Info-mode
		  eww-mode
		  debugger-mode
                  compilation-mode
		  term-mode))
    (evil-nothanks-mode mode)))

