;;; undo-tree
(use-package undo-tree
  :diminish
  :ensure t
  :init (global-undo-tree-mode)
  :config
  (progn (setq undo-tree-auto-save-history nil)

         (require 'ag-hydra--main)
         (add-to-list 'hydra-mini/++extras
                      '("u" undo-tree-visualize "undo-tree" ))
         ))

;;;
(provide 'ag-feat-undo-tree)
