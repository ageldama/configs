

(add-hook 'c-mode-hook
          (lambda ()
            ;; (when (featurep 'hideshow)
            ;;   (hs-minor-mode +1))
            (when (featurep 'ggtags)
              (when (featurep 'eldoc)
                (setq-local eldoc-documentation-function
                            #'ggtags-eldoc-function)
                (eldoc-mode +1))
              (ggtags-mode +1))))


(defhydra hydra-lang-c ()
  "c"

  ("\\" ff-find-other-file "hdr<->src" :exit t)

  ("SPC" nil))


(lang-mode-hydra-set 'c-mode-hook 'hydra-lang-c/body)


(provide 'ag-feat-c)
