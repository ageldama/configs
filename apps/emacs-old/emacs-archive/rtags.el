(defcustom project-build-command "ninja"
  "Default command to build project"
  :type 'string)

(require 'flycheck)


(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(use-package clang-format :ensure t :pin melpa
  :config
  (defun clang-format-dwim ()
    (interactive)
    (if mark-active
        (call-interactively #'clang-format-region)
      (clang-format-buffer))))

(use-package rtags :ensure t :pin melpa
  :config (progn (setq rtags-autostart-diagnostics nil)
                 (setq rtags-completions-enabled t)
                 (require 'company)
                 (push 'company-rtags company-backends)
                 (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
                 (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
                 (add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
                 ;;
                 (define-key c-mode-base-map (kbd "M-.") #'rtags-find-symbol-at-point)
                 (define-key c-mode-base-map (kbd "M-,") #'rtags-location-stack-back)
                 ;; (define-key c-mode-base-map (kbd "M->") #'rtags-find-references-at-point)
                 ;; (define-key c-mode-base-map (kbd "M-;") #'rtags-find-file)
                 ;; (define-key c-mode-base-map (kbd "C-.") #'rtags-find-symbol)
                 ;; (define-key c-mode-base-map (kbd "C-,") #'rtags-find-references)
                 ;; (define-key c-mode-base-map (kbd "C-<") #'rtags-find-virtuals-at-point)
                 ;; (define-key c-mode-base-map (kbd "M-i") #'rtags-imenu)
                 ))

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

(add-hook 'c-mode-hook 'rtags-eldoc-mode)
(add-hook 'c++-mode-hook 'rtags-eldoc-mode)

;;; flycheck + rtags backend.
(when nil ;; DISABLED -- not working as intended
  (use-package flycheck-rtags :ensure t :pin melpa)

  (defun my-flycheck-rtags-setup ()
    "Configure flycheck-rtags for better experience."
    (flycheck-select-checker 'rtags)
    (setq-local flycheck-check-syntax-automatically t)
    (setq-local flycheck-highlighting-mode t))

  (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
  (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
  (add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)
  )

;; (add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)
;; (defun my-hack-local-vars-mode-hook ()
;;   "Run a hook for the major-mode after the local variables have been processed."
;;   (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(defun my-c-c++-mode-hook2 ()
  (interactive)
  ;; TODO: (setq flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck))
  ;; TODO: (flycheck-select-checker 'c/c++-clang-tidy)
  ;; TODO (flycheck-c/c++-clang-and-gcc-setup)
  (flycheck-mode))

;; (add-hook 'c-mode-hook 'my-c-c++-mode-hook2)
;; (add-hook 'c++-mode-hook 'my-c-c++-mode-hook2)



;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

;; only run this if rtags is installed
(when (require 'rtags nil :noerror)
  ;; make sure you have company-mode installed
  (require 'company)

  ;; TODO (define-key c-mode-base-map (kbd "M-.") (function rtags-find-symbol-at-point))
  ;; TODO (define-key c-mode-base-map (kbd "M-,") (function rtags-find-references-at-point))
  
  ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
  ;; TODO (define-key prelude-mode-map (kbd "C-c r") nil)

  ;; install standard rtags keybindings. Do M-. on the symbol below to
  ;; jump to definition and see the keybindings.
  (rtags-enable-standard-keybindings)
  ;; comment this out if you don't have or don't use helm
  ;; (setq rtags-use-helm t)

  ;; company completion setup
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  (global-company-mode)
  ;; (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))

  ;; use rtags flycheck mode -- clang warnings shown inline
  (require 'flycheck-rtags)
  ;; c-mode-common-hook is also called by c++-mode
  (add-hook 'c-mode-common-hook #'setup-flycheck-rtags))





(use-package rmsbolt :ensure t :pin melpa)


(defun c-c++-rmsbolt-this ()
  (interactive)
  (rmsbolt-mode)
  (rmsbolt-compile))



;;;
(when (fboundp 'general-create-definer)
  (my-local-leader-def :keymaps 'c-mode-base-map
    ;; RTags
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

    "f" 'clang-format-dwim

    ;; TODO "b" 'compile-in-project-build-path

    "M-b" 'c-c++-rmsbolt-this
    ))


;; EOF
