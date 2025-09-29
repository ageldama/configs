
(require 'xref)


(use-package grep
  :ensure nil

  :commands (grep lgrep rgrep)

  :config
  (global-set-key (kbd "M-s g g") 'grep)
  (global-set-key (kbd "M-s g r") 'rgrep)
  (global-set-key (kbd "M-s g l") 'lgrep)
  (global-set-key (kbd "M-s g f") 'grep-find)
  ;; (global-set-key (kbd "M-s g r") 'rg)
  ;; (global-set-key (kbd "M-s g d") 'deadgrep)

  (setq grep-save-buffers nil)
  (setq grep-use-headings t) ; Emacs 30

  ;; NOTE 그냥 라인 M-n/M-p 제대로 동작 않아서 GNU grep으로 복귀.
  ;; (let ((executable (or (executable-find "rg") "grep"))
  ;;       (rgp (string-match-p "rg" grep-program)))
  ;;   (setq grep-program executable)
  ;;   (setq grep-template
  ;;         (if rgp
  ;;             "/usr/bin/rg -nH --null -e <R> <F>"
  ;;           "/usr/bin/grep <X> <C> -nH --null -e <R> <F>"))
  ;;   (setq xref-search-program (if rgp 'ripgrep 'grep)))
  )



(provide 'ag-grep)
