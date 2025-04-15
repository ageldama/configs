
(use-package recentf
  :init
  (setq
    recentf-save-file "~/.emacs.d/recentf"
    recentf-max-saved-items 10000
    recentf-max-menu-items 5000
    )
  (recentf-mode 1)
  (run-at-time nil (* 5 60) 'recentf-save-list)
  )


(provide 'ag-feat-recentf)
