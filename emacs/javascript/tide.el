;;; js2-mode.
(use-package js2-mode :ensure t :pin melpa
  :config (progn (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
		 (add-to-list 'interpreter-mode-alist '("node" . js2-mode))))

;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))


;;; TIDE.

(use-package tide :ensure t :pin melpa)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; formats the buffer before saving
;; TODO: only with .js/.ts??? -- (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'js2-mode-hook #'setup-tide-mode)

(flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)



;; NPM integration
(use-package npm-mode :ensure t :pin melpa)


;;; tide관련 버퍼들에서 evil 끄기.
(defun tide-documentation-buffer-p (buf)
  (string-equal "*tide-documentation*" (buffer-name buf)))

(defun evil-turn-off-on-buffers (buffer-pred)
  (dolist (buf (-filter buffer-pred (buffer-list)))
    (with-current-buffer buf
      (message "EVIL-TURN-OFF: %S" buf)
      (evil-local-mode -1))))

(defun evil-turn-off-tide-documentation-buffer ()
  (evil-turn-off-on-buffers #'tide-documentation-buffer-p))

(advice-add 'tide-command:quickinfo :after
	    (lambda (&rest r)
	      (run-at-time 0.2 nil
			   #'evil-turn-off-tide-documentation-buffer)))

(dolist (i '(
	     tide-references-mode
	     tide-project-errors-mode
	     ))
  (evil-nothanks-mode i))

;;; General keymap.
(when (fboundp 'general-create-definer)
  (progn
    ;; TIDE
    (general-define-key
     :keymaps 'tide-mode-map
     :prefix "C-c"
     "m" '(:ignore t :which-key "tide"))
    (general-define-key
     :keymaps 'tide-mode-map
     :prefix "C-c m"
     ;;;
     "d" 'tide-documentation-at-point
     "r" 'tide-references
     "i" 'tide-organize-imports
     "R" 'tide-rename-symbol
     "f" 'tide-format
     "1" 'tide-fix
     "F" 'tide-refactor
     "E" 'tide-project-errors
     "T" 'tide-jsdoc-template
     ;;;
     "," 'tide-jump-back
     "." 'tide-jump-to-definition
     ">" 'tide-jump-to-implementation
     ;;;
     "` R" 'tide-restart-server
     "` v" 'tide-verify-setup
     )
    ;; JSON
    (general-define-key
     :keymaps 'json-mode-map
     :prefix "C-c"
     "m" '(:ignore t :which-key "json"))
    (general-define-key
     :keymaps 'json-mode-map
     :prefix "C-c m"
     ;;;
     "p" 'jsons-print-path
     "f" 'json-mode-beautify
    )
    ))



;;;
(defconst agelmacs/layer/tide t)
;;; EOF.
