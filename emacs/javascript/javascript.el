;;; js2-mode.
(use-package js2-mode :ensure t :pin melpa
  :config (progn (setq js-indent-level 2)
                 (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
                 (add-to-list 'interpreter-mode-alist '("node" . js2-mode))))

;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))

;; TODO: KEYBIND -- jsons-print-path
;; TODO: KEYBIND -- json-mode-beautify

;;; TODO: http://ternjs.net/
;; (use-package tern :ensure t :pin melpa
;;   :config (add-hook 'js-mode-hook (lambda () (tern-mode t))))

;; (tern-use-server 11111 "127.0.0.1")


;;; TODO: https://github.com/proofit404/company-tern

;;; TODO: https://github.com/nicolaspetton/indium
(use-package indium :ensure t :pin melpa
  :config (progn (dolist (i '(indium-debugger-frames-mode
			      indium-debugger-locals-mode
			      indium-debugger-mode
			      indium-inspector-mode
			      ;;indium-interaction-mode
			      indium-list-scripts-mode
			      indium-repl-mode))
		   (evil-nothanks-mode i))
		 (add-hook 'js2-mode-hook #'indium-interaction-mode)))


;;; TODO: (PERHAPS) http://js-comint-el.sourceforge.net/
