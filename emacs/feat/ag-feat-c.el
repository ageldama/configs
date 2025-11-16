

(when (fboundp 'defhydra)
  (eval '(defhydra hydra-lang-c ()
           "c"

           ("\\" ff-find-other-file "hdr<->src" :exit t)

           ("SPC" nil))))


(dolist (mode '(c-mode-hook c++-mode-hook))
  (add-hook mode
            (lambda ()
              ;; (when (featurep 'hideshow)
              ;;   (hs-minor-mode +1))
              (when (featurep 'ggtags)
                (when (featurep 'eldoc)
                  (setq-local eldoc-documentation-function
                              #'ggtags-eldoc-function)
                  (eldoc-mode +1))
                (ggtags-mode +1))))

  (require 'ag-lang-mode)
  (lang-mode-hydra-set mode 'hydra-lang-c/body)
  )


(provide 'ag-feat-c)
