(require 'dired)
(require 'wdired)


(setq
 dired-dwim-target t
 dired-deletion-confirmer 'y-or-n-p
 dired-recursive-deletes 'top
 dired-recursive-copies 'always
 wdired-confirm-overwrite t
 wdired-use-interactive-rename t
 )


;;;
(provide 'ag-dired)
