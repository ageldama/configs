;;; js2-mode.
(use-package js2-mode :ensure t :pin melpa
  :config (progn (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
		 (add-to-list 'interpreter-mode-alist '("node" . js2-mode))))

;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))

;; TODO: KEYBIND -- jsons-print-path
;; TODO: KEYBIND -- json-mode-beautify


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

;; aligns annotation to the right hand side
;; (setq company-tooltip-align-annotations t)

;; formats the buffer before saving
;; TODO: only with .js/.ts -- (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'js2-mode-hook #'setup-tide-mode)

(flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)


;; DONE: ~require~ 이거 왜 에러로 체크? -- 그냥 두번째 불러오니까 괜춘한데?


;; TODO: 실행, 디버그, 테스트?


;;; ~tidy-documentation~ 에서 evil끄기?
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


(defconst agelmacs/layer/tide t)
;;; EOF.
