
(defvar-local lang-mode-hydra nil)


(defmacro lang-mode-hydra-set (mode-hook hydra-body)
  `(add-hook ,mode-hook
             (lambda () (setq-local lang-mode-hydra
                                    (symbol-function ,hydra-body)))))



(defun do-lang-mode-hydra ()
  (interactive)
  (if lang-mode-hydra
      (call-interactively lang-mode-hydra)
    ;; else
    (message "Null lang-mode-hydra local-var")))



(provide 'ag-lang-mode)
