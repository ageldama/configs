;;; json-mode.
(use-package json-mode :ensure t :pin melpa
  :config (add-to-list 'auto-mode-alist '("\\.json" . json-mode)))


(defhydra hydra-lang-json ()
  "json"
  ("p" jsons-print-path "print-path" :exit t)
  ("f" json-mode-beautify "beautify" :exit t)

  ("SPC" nil))

(lang-mode-hydra-set 'json-mode-hook 'hydra-lang-json/body)


(provide 'ag-feat-json)
