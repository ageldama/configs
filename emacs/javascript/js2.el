;;; js2-mode.
(use-package js2-mode :ensure t :pin melpa
  :config (progn (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
		 (add-to-list 'interpreter-mode-alist '("node" . js2-mode))))

;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))



;; NPM integration
(use-package npm-mode :ensure t :pin melpa)

;; RUN!
(add-hook 'js2-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "node " (shell-quote argument buffer-file-name)))))

;;; General keymap.
(when (fboundp 'general-create-definer)
  (progn
    ;; TIDE
    (general-define-key
     :keymaps 'js2-mode-map
     :prefix "C-c"
     "m" '(:ignore t :which-key "js2"))
    (general-define-key
     :keymaps 'js2-mode-map
     :prefix "C-c m"
    ;; NPM
    "n" (general-simulate-key "C-c n" :name npm)
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
(defconst agelmacs/layer/js2 t)
;;; EOF.
