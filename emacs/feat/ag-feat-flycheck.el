;;; flycheck.
(use-package flycheck ;:ensure t :pin melpa
  :config (progn
            (global-flycheck-mode +1)

            (when (fboundp 'defhydra)
              (eval '(progn (defhydra hydra-flycheck
                       (:pre (flycheck-list-errors)
                             :post (quit-windows-on "*Flycheck errors*"))
                       "Errors"
                       ("l" flycheck-list-errors "list" :exit t)
                       ("f" flycheck-error-list-set-filter "Filter")
                       ("j" flycheck-next-error "Next")
                       ("k" flycheck-previous-error "Previous")
                       ("gg" flycheck-first-error "First")
                       ("G" (progn (goto-char (point-max)) (flycheck-previous-error)) "Last")
                       ("?" flycheck-describe-checker "Desc-Chker")
                       ("c" flycheck-buffer "ChkBuf")
                       ("C" flycheck-compile "Compile")
                       ("s" flycheck-select-checker "Sel-Chker")
                       ("v" flycheck-verify-setup "Verify-Setup")
                       ("x" flycheck-disable-checker "Disable-Chker")
                       ("e" flycheck-explain-error-at-point "Explain-Err")
                       ("C-w" flycheck-copy-errors-as-kill "Copy-Err")
                       ("SPC" nil))

              (require 'ag-hydra--main)
              (add-to-list 'hydra-mini/++extras
                           '("M-c" hydra-flycheck/body "flychk")))))

              ))


(provide 'ag-feat-flycheck)
