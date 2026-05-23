(use-package add-node-modules-path :ensure t :pin melpa)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  )

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(setq typescript-indent-level 2)


(defvar *tide/tide-format-before-save-2* t)

(defun tide-format-before-save-2 ()
  (interactive)
  (when *tide/tide-format-before-save-2*
    (tide-format-before-save)))

(defun tide-flycheck-select-eslint ()
  (interactive)
  (flycheck-select-checker 'javascript-eslint))

(use-package tide
  :ensure t :pin melpa
  :config (setq typescript-indent-level 2)
  :after (typescript-mode company flycheck add-node-modules-path)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . tide-flycheck-select-eslint)
         (before-save . tide-format-before-save-2)))

;; (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
(add-hook 'typescript-mode-hook
          (defun my-ttypescript-mode-setup ()
            (flycheck-select-checker 'javascript-eslint)))


;;; TSX
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)


;;; keymap.

(defhydra hydra-lang-tide ()
  "tide"
     ("?" tide-documentation-at-point "doc" :exit t)
      
     ("R s" tide-rename-symbol "ren-sym" :exit t)
     ("R R" tide-refactor "refactor" :exit t)
     ("R f" tide-rename-file      "ren-file" :exit t)
      
     ("f" tide-format "fmt" :exit t)
     ("1" tide-fix "fix" :exit t)
     ("o" tide-organize-imports      "org-imp" :exit t)
     ("!" tide-project-errors "proj-errs" :exit t)
      
     ("*" tide-jsdoc-template "jsdoc" :exit t)
      
     ("M-_" tide-add-tslint-disable-next-line "tslint-next" :exit t)
      
     ("<" tide-references       "ref" :exit t)
     ("," tide-jump-back "jmp-back" :exit t)
     ("." tide-jump-to-definition "jmp-def" :exit t)
     (">" tide-jump-to-implementation "jmp-impl" :exit t)
      
      ;;
     ("` R" tide-restart-server "restart-srv" :exit t)
     ("` v" tide-verify-setup "verify-setup" :exit t)
     ("` l" tide-list-servers "list-srvs" :exit t)

     ("SPC" nil))

(lang-mode-hydra-set 'typescript-mode-hook 'hydra-lang-tide/body)


;;;
(defconst agelmacs/layer/tide t)
;;; EOF.
