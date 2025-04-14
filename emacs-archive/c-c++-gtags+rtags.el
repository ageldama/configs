
(defun my-c-c++-rtags+gtags-get-build-dir () (getenv "BUILD_DIR"))

(defun project-rtags? ()
  (not (null (my-c-c++-rtags+gtags-get-build-dir))))

;;;

(require 'flycheck)

(use-package flycheck-clang-tidy
  :pin melpa :ensure t
  :after flycheck
  :hook
  (flycheck-mode . flycheck-clang-tidy-setup)
  :config
  (flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-clang)
  (flycheck-add-next-checker 'c/c++-clang-tidy 'c/c++-gcc)
  )


(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))


(use-package counsel-gtags :ensure t :pin melpa)

(use-package rtags :ensure t :pin melpa
  :config
  (progn (setq rtags-autostart-diagnostics nil)
         (setq rtags-completions-enabled t)))

(use-package company-rtags :ensure t :pin melpa)


;;; eldoc
(use-package eldoc :ensure t :pin melpa :diminish eldoc-mode)

;;; Rtags + Eldoc:
;; https://github.com/Andersbakken/rtags/issues/987
(defun fontify-string (str mode)
  "Return STR fontified according to MODE."
  (with-temp-buffer
    (insert str)
    (delay-mode-hooks (funcall mode))
    (font-lock-default-function mode)
    (font-lock-default-fontify-region
     (point-min) (point-max) nil)
    (buffer-string)))

(defun rtags-eldoc-function ()
  (let ((summary (rtags-get-summary-text)))
    (and summary
         (fontify-string
          (replace-regexp-in-string
           "{[^}]*$" ""
           (mapconcat
            (lambda (str) (if (= 0 (length str)) "//" (string-trim str)))
            (split-string summary "\r?\n")
            " "))
          major-mode))))

(defun rtags-eldoc-mode ()
  (interactive)
  (setq-local eldoc-documentation-function #'rtags-eldoc-function)
  (eldoc-mode 1))

(defun my-c-c++-eldoc ()
  (interactive)
  (when (project-rtags?)
    (rtags-eldoc-mode)))

(add-hook 'c-mode-hook 'my-c-c++-eldoc)
(add-hook 'c++-mode-hook 'my-c-c++-eldoc)




;;; flycheck + rtags backend.
;; DISABLED -- not working as intended
;; (use-package flycheck-rtags :ensure t :pin melpa)
;; (defun my-flycheck-rtags-setup ()
;;   "Configure flycheck-rtags for better experience."
;;   (flycheck-select-checker 'rtags)
;;   (setq-local flycheck-check-syntax-automatically t)
;;   (setq-local flycheck-highlighting-mode t))
;; (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
;; (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
;; (add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)

(load-library (f-join langsup-base-path "compile-commands-json"))

(defcustom read-project-compile-commands #'read-compile-commands-resolved-by-rtags
  "compile-commands reader function"
  :type 'function)

;;; flycheck gcc/clang fixes
(defun flycheck-c/c++-clang-and-gcc-setup ()
  (interactive)
  (let ((inc-dirs  (compile-commands-json/include-dirs read-project-compile-commands)))
     ;;(message "Include-Dirs: %S" inc-dirs)
     (setq-local flycheck-clang-include-path inc-dirs)
     (setq-local flycheck-gcc-include-path inc-dirs)))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(defun my-c-c++-rtags-hook ()
  (require 'company)
  (push 'company-rtags company-backends)
  (rtags-start-process-unless-running)
  (setq flycheck-clang-tidy-build-path (my-c-c++-rtags+gtags-get-build-dir)))

(defun my-c-c++-gtags-hook ()
  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)
  ;;
  (counsel-gtags-mode))


(defun my-c-c++-mode-hook2 ()
  (interactive)
  ;; TODO: (setq flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck))
  ;; TODO: (flycheck-select-checker 'c/c++-clang-tidy)
  (if (project-rtags?)
      (my-c-c++-rtags-hook)
    (my-c-c++-gtags-hook))
  (flycheck-c/c++-clang-and-gcc-setup)
  (flycheck-mode)
  ;;
  (c-c++-bind-key-map)
  )

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook2)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook2)


;;;
(defun rtags-local-defs ()
  (message "Using RTags")
  (define-key c-mode-base-map (kbd "M-.") #'rtags-find-symbol-at-point)
  (define-key c-mode-base-map (kbd "M-,") #'rtags-location-stack-back)
  (define-key c-mode-base-map (kbd "M-?") #'rtags-find-references-at-point)
  ;;
  (my-local-leader-def :keymaps 'c-mode-base-map
    "?" 'rtags-print-symbol-info
    "." 'rtags-find-symbol-at-point
    "," 'rtags-location-stack-back
    ">" 'rtags-find-references-at-point
    ";" 'rtags-find-file
    "v" 'rtags-find-virtuals-at-point
    "[" 'rtags-previous-match
    "]" 'rtags-next-match
    "!" 'rtags-fix-fixit-at-point
    "i" 'rtags-imenu
    "d" 'rtags-diagnostics
    "D" 'rtags-dependency-tree

    "t" '(:ignore t :which-key "rtags")
    "t s" 'rtags-find-symbol
    "t r" 'rtags-find-references
    "t R" 'rtags-references-tree
    ))

(defun gtags-local-defs ()
  (message "Using GNU Global")
  (my-local-leader-def :keymaps 'c-mode-base-map
    "," 'counsel-gtags-go-backward
    "." 'counsel-gtags-dwim

    "g" '(:ignore t :which-key "gtags")
    "g d" 'counsel-gtags-find-definition
    "g r" 'counsel-gtags-find-reference
    "g s" 'counsel-gtags-find-symbol
    "g c" 'counsel-gtags-create-tags
    "g u" 'counsel-gtags-update-tags
    ))

(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (if (project-rtags?)
        ;; RTags
        (rtags-local-defs)
      ;; GNU Global
      (gtags-local-defs))))


;; EOF
