
;;; yas
(use-package yasnippet :ensure t :pin melpa
  :config (progn
            ;; no more tabs:
            ;; (define-key yas-minor-mode-map [(tab)] nil)
            ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
            ;; desc
            ;; (define-key yas-minor-mode-map (kbd "C-c C-c TAB") 'yas-expand)
            (define-key yas-minor-mode-map (kbd "C-c & d")
                        'yas-describe-tables)
            (define-key yas-minor-mode-map (kbd "C-c & TAB") 'yas-expand)

            ;; (setq hippie-expand-try-functions-list
            ;;       (append hippie-expand-try-functions-list
            ;;               '(yas-hippie-try-expand)))

            ;;
            (yas-global-mode +1)))


(defhydra hydra-yas ()
  "
Yasnippet^^
---------------------------------
_TAB_ expand
_d_ desc
_m_ toggle
_s_ ins
_n_ new
_v_ visit

_SPC_ cancel
"
  ("TAB" yas-expand :exit t)
  ("d" yas-describe-tables :exit t)
  ("m" yas-minor-mode :exit nil)
  ("s" yas-insert-snippet :exit t)
  ("n" yas-new-snippet :exit t)
  ("v" yas-visit-snippet-file :exit t)
  ("SPC" nil)
  )


(use-package yasnippet-snippets :ensure t :pin melpa :after yasnippet)




;; ("M-y" hydra-yas/body "yas" :exit t)


(provide 'ag-feat-yas)
