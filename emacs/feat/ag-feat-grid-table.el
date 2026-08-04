(quelpa '(grid-table :fetcher github :repo "yibie/grid-table"))

(use-package grid-table
  ;; :vc (:fetcher github :repo "yibie/grid-table")

  :config
  (require 'grid-table)
  (require 'grid-table-plugins)

  (setq grid-table-default-save-directory "~/Documents")

  (setq grid-table-image-target-char-height 8)
  (setq grid-table-image-max-width-ratio 0.9))


(provide 'ag-feat-grid-table)
