
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

            ;; NOTE: 생각보다 profiler 돌리면 오래 걸림. ㅎㅎ
            ;; (yas-global-mode +1)
            ))


(defvar ag-feat-yas-global-mode nil)


(defun ag-feat-yas--maybe-activate+only-once--yas-global-mode-maybe ()
  (interactive)
  (when (and (not (defined-symbol-value 'yas-global-mode))
             ag-feat-yas-global-mode)
    (message ";;; NOTE: yas-global-mode +1")
    (yas-global-mode +1)))


(defun ag-feat-yas--install-hook (&optional hook-sym)
  "생각보다 무거워서 lazy-init + only-once"
  (let ((hook-sym* (or hook-sym 'find-file-hook)))
    (add-hook hook-sym*
              #'ag-feat-yas--maybe-activate+only-once--yas-global-mode-maybe)))



(when (fboundp 'defhydra)
(eval '(defhydra hydra-yas ()
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
  ))

  (require 'ag-hydra--main)
  (add-to-list 'hydra-mini/++extras
             '("y" hydra-yas/body "yas"))
)


(use-package yasnippet-snippets :ensure t :pin melpa :after yasnippet)




;; ("M-y" hydra-yas/body "yas" :exit t)


(provide 'ag-feat-yas)
