(defvar input-method/*stack* '())

(defun input-method/save ()
  (interactive)
  (push current-input-method input-method/*stack*)
  ;; (message "SAVE: %s" input-method/*stack*)
  )

(defun input-method/save+reset ()
  (interactive)
  (input-method/save)
  (deactivate-input-method))

(defun input-method/restore ()
  (interactive)
  (let ((im (pop input-method/*stack*)))
    ;; (message "RESTORE: %s => %s"
    ;;          input-method/*stack*
    ;;          im)
    (if (null im) (deactivate-input-method)
      (activate-input-method im))))


(defmacro input-method/with-save+restore (&rest body)
  `(progn
     (input-method/save+reset)
     ,@body
     (input-method/restore)))



(provide 'ag-input-method-stack)

;;;; [2026-04-23 Thu 13:47]
;;;; 그렇게 만족스럽진 못함. hydra이 자체적으로 input-method 지원을 해준다고는 하던데,
;;;; 그거 동작도 않는거 같다. (eg. C-z)
;;;;
;;;; 그리고 (defhydra ... (:pre ... :post ...)도 의도랑 좀 다르게 동작함.
;;;; --> :post이 불리지 않거나, 아예 먼저 불려 버려서 문제 같아.
;;;;
;;;; 그래서 그냥 단순하게 hydra 진입시 deactivate-input-method 😥
;;;;
;;;; evil이랑 쓸때엔 좀 이런건 깔끔했던거 같아서 그립기도.
