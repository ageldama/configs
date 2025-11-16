
(require 'expand-region)


;;; https://cute-jumper.github.io/emacs/2016/02/22/my-simple-setup-to-avoid-rsi-in-emacs

(defhydra hydra-expand-region
  (:body-pre (call-interactively 'set-mark-command)
             :exit nil)
  "hydra for mark commands"
  ("=" er/expand-region "expand")
  ("-" (lambda () (interactive)
         (er/expand-region -1)) "-")
  ("0" (lambda () (interactive)
         (er/expand-region 0)) "0")
  ("P" er/mark-inside-pairs "in-pair")
  ("Q" er/mark-inside-quotes "in-quote")
  ("p" er/mark-outside-pairs "out-pair")
  ("q" er/mark-outside-quotes "out-quote")
  ("d" er/mark-defun "defun")
  ("c" er/mark-comment "comment")
  ("." er/mark-text-sentence "sentence")
  ("h" er/mark-text-paragraph "paragraph")
  ("w" er/mark-word "word")
  ("u" er/mark-url "url")
  ("m" er/mark-email "email")
  ("s" er/mark-symbol "symbol")
  ("j" (funcall 'set-mark-command t) :exit nil)
  ("SPC" nil))


(global-set-key (kbd "C-+") 'hydra-expand-region/body)

(require 'ag-hydra--main)
(add-to-list 'hydra-mini/++extras
             '("=" hydra-expand-region/body "exp-region"))



;;;
(provide 'ag-feat-hydra--expand-region)
