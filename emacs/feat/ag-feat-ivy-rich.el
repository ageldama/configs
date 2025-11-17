;;; ivy 화면 옆에 key, docstring 등을 더 표시.
;;;
;;; 키바인딩을 익히거나 찾아낼 때에 도움이 된다.

(use-package ivy-rich :ensure t ;:pin melpa
  :config (ivy-rich-mode +1))


(provide 'ag-feat-ivy-rich)
