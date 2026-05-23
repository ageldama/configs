(use-package helm-swoop :ensure t :pin melpa
  :config (progn
            (global-set-key (kbd "C-s") 'helm-swoop)
	    ;; If there is no symbol at the cursor, use the last used words instead.
	    (setq helm-swoop-pre-input-function
		  (lambda ()
		    (let (($pre-input (thing-at-point 'symbol)))
		      (if (eq (length $pre-input) 0)
			  (if (boundp 'helm-swoop-pattern) ;; this variable keeps the last used words
                              helm-swoop-pattern "")
                        $pre-input))))
	    ;; When doing isearch, hand the word over to helm-swoop
	    (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
	    ;; From helm-swoop to helm-multi-swoop-all
	    (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)))
