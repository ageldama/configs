;;; json-mode.
(use-package json-mode ;:ensure t :pin melpa
  :config (progn
            (add-to-list 'auto-mode-alist '("\\.json" . json-mode))
            (when (fboundp 'defhydra)
              (eval '(progn
                       (defhydra hydra-lang-json ()
                       "json"
                       ("p" jsons-print-path "print-path" :exit t)
                       ("f" json-mode-beautify "beautify" :exit t)

                       ("SPC" nil))
              (require 'ag-lang-mode)
              (lang-mode-hydra-set 'json-mode-hook 'hydra-lang-json/body))))))

(provide 'ag-feat-json)
