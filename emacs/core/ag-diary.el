(require 'ag-diary-impl)

(defvar *v3/plan-path* "~/P/v3/PLAN.org")

(defun v3/open-plan ()
  (interactive)
  (find-file *v3/plan-path*))


;;;
(provide 'ag-diary)
