;;; Only builtin Eglot, without package `lsp'.

(use-package eglot :ensure t
  :config

(define-key eglot-mode-map (kbd "C-c e p") #'flymake-goto-prev-error)
(define-key eglot-mode-map (kbd "C-c e n") #'flymake-goto-next-error)
(define-key eglot-mode-map (kbd "C-c e l") #'flymake-show-buffer-diagnostics)
(define-key eglot-mode-map (kbd "C-`") #'flymake-goto-next-error)

(define-key eglot-mode-map (kbd "C-c RET") #'eglot-code-actions)

(when (fboundp 'defhydra)
  (define-key eglot-mode-map (kbd "C-c e e") #'hydra-eglot/body)

  (eval '(defhydra hydra-eglot (:color pink :hint nil :exit t)
    "
_SPC_: close
_=_: fmt                _?_: eldoc
_._: xref               _i_: imenu
_TAB_: compl.           _e_: code-action

^Eglot^                ^Type^               ^Diag^
^^^^^^^^--------------------------------------------------------------
_: :_: eglot!          _t h_: inlay-hints   _! !_: diag/buf.
_: r_: reconn.         _t t_: type-hier.    _! P_: diag/proj.
_: k_: shutdown        _t c_: call-hier.     ^ ^           
_: K_: shutdown-all     ^ ^                  ^ ^

"

    ("="        #'eglot-format "fmt" )

    (": :" #'eglot "eglot!")
    (": r" #'eglot-reconnect "reconnect")
    (": k" #'eglot-shutdown "shutdown")
    (": K" #'eglot-shutdown-all "shutdown-all")

    ("t h" #'eglot-inlay-hints-mode "inlay-hints")
    ("t t" #'eglot-show-type-hierarchy "type-hier.")
    ("t c" #'eglot-call-type-hierarchy "call-hier.")

    ("?" #'eldoc "eldoc")

    ("! !" #'flymake-show-buffer-diagnostics "diag / buf.")
    ("! P" #'flymake-show-project-diagnostics "diag / proj.")

    ("." #'xref-find-definitions "xref/def")
    ("i" #'imenu "imenu")
    ("TAB" #'completion-at-point "completion")

    ("e" #'eglot-code-actions "code")
    ("E o" #'eglot-code-action-organize-imports "code / org-imports")
    ("E q" #'eglot-code-action-quickfix "code / quickfix")
    ("E x" #'eglot-code-action-extract "code / extract")
    ("E i" #'eglot-code-action-inline "code / inline")
    ("E r" #'eglot-code-action-rewrite "code / rewrite")

    ;; exit
    ("SPC" nil)
    ))

  (require 'ag-hydra--main)
  (add-to-list 'hydra-mini/++extras
             '("e" hydra-eglot/body "eglot"))

  ))



(provide 'ag-feat-eglot)
