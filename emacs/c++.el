(defun my-c-c++-build-dir () (getenv "BUILD_DIR"))

(defun parse-compile-commands-json-inc-dirs (dir)
  (let* ((fn (s-concat dir "/compile_commands.json"))
         (inc-dirs
          ;; https://github.com/ageldama/go-parse-compile-cmds
          (shell-command-to-string (s-concat "go-parse-compile-cmds " fn))))
    (mapcar (lambda (s) (if (s-prefix? "/" s) s
                          (s-concat dir "/" s)))
            (s-split "\n" inc-dirs))))

;;; Debugger, CMake, Modern-CPP

(use-package realgud :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))


;;; flycheck + clang-tidy
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

;;; RTags
(use-package rtags :ensure t :pin melpa
  :config
  (progn (setq rtags-autostart-diagnostics nil)
         (setq rtags-completions-enabled t)))

(setq rtags-verify-protocol-version nil)

(use-package company-rtags :ensure t :pin melpa)


(defun rtags-able? ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (not (s-blank?
          (with-temp-buffer
            (rtags-call-rc "-P" fn :noerror t)
            (buffer-string))))))


;;; RTags + ElDoc

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




;;; RMSBolt
(use-package rmsbolt :ensure t :pin melpa)

(load-library (f-join langsup-base-path "compile-commands-json"))


(defun c-c++-rmsbolt-this-or-off ()
  (interactive)
  (if rmsbolt-mode
      ;; then, turn-off
      (rmsbolt-mode -1)
    ;; else
    (progn
      (setq-local rmsbolt-command
                  (compile-commands-json/rmsbolt-command
                   (make-read-compile-commands-in-dir (my-c-c++-build-dir))
                   (buffer-file-name)))
      ;;
      (rmsbolt-mode)
      (rmsbolt-compile))))



;;; gtags : GNU Global
(use-package counsel-gtags :ensure t :pin melpa)


;;; flycheck gcc/clang fixes
(defvar my-c-c++-touched nil)

(defun flycheck-c/c++-setup ()
  (interactive)
  (let ((inc-dirs  (parse-compile-commands-json-inc-dirs
                    (my-c-c++-build-dir))))
    (message "Include-Dirs: %S" inc-dirs)
    (setq-local flycheck-clang-include-path inc-dirs)
    (setq-local flycheck-gcc-include-path inc-dirs)
    (setq-local flycheck-clang-tidy-build-path
                (my-c-c++-build-dir)))
  (setq-local my-c-c++-touched t)
  (ignore-errors
    (flycheck-buffer)))



;;;
(defun my-c-c++-gtags-hook ()
  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)
  ;;
  (counsel-gtags-mode))


(defun my-c-c++-rtags-hook ()
  (require 'company)
  (push 'company-rtags company-backends)
  (rtags-start-process-unless-running)
  (setq flycheck-clang-tidy-build-path (my-c-c++-build-dir)))
  

(defun my-c-c++-mode-hook ()
  (interactive)
  (if (rtags-able?)
      (my-c-c++-rtags-hook)
    (my-c-c++-gtags-hook))
  (unless my-c-c++-touched
    (run-with-timer 0.5 nil #'flycheck-c/c++-setup))
  (flycheck-mode)
  ;; keys
  (c-c++-bind-key-map)
  ;; rmsbolt
  (setq-local rmsbolt-default-directory (my-c-c++-build-dir))
  )


(defun my-c-c++-mode-reset ()
  (interactive)
  (setq-local my-c-c++-touched nil)
  (my-c-c++-mode-hook))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook)


(defun my-c-c++-eldoc ()
  (interactive)
  (when (rtags-able?)
    (rtags-eldoc-mode)))

(add-hook 'c-mode-hook 'my-c-c++-eldoc)
(add-hook 'c++-mode-hook 'my-c-c++-eldoc)



(defun gtags-local-defs ()
  (message "Using GNU Global")
  (my-local-leader-def :keymaps 'c-mode-base-map
    "` !" 'my-c-c++-mode-reset
    "` b" 'c-c++-rmsbolt-this-or-off
    
    "," 'counsel-gtags-go-backward
    "." 'counsel-gtags-dwim

    "g" '(:ignore t :which-key "gtags")
    "g d" 'counsel-gtags-find-definition
    "g r" 'counsel-gtags-find-reference
    "g s" 'counsel-gtags-find-symbol
    "g c" 'counsel-gtags-create-tags
    "g u" 'counsel-gtags-update-tags
    "g !" 'flycheck-c/c++-setup
    ))

(defun rtags-local-defs ()
  (message "Using RTags")
  (define-key c-mode-base-map (kbd "M-.") #'rtags-find-symbol-at-point)
  (define-key c-mode-base-map (kbd "M-,") #'rtags-location-stack-back)
  (define-key c-mode-base-map (kbd "M-?") #'rtags-find-references-at-point)
  ;;
  (my-local-leader-def :keymaps 'c-mode-base-map
    "` !" 'my-c-c++-mode-reset
    "` b" 'c-c++-rmsbolt-this-or-off
    
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

(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (if (rtags-able?)
        (rtags-local-defs)
      (gtags-local-defs))))


;;; EOF
