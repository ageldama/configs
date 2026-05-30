
(use-package disaster
  :commands (disaster)
  :init
  ;; (setq disaster-assembly-mode #'nasm-mode)

  (define-key c-mode-map (kbd "C-c d") 'disaster)

  )

(provide 'ag-feat-disaster)
