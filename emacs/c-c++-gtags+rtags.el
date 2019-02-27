(defcustom project-build-path nil
  "Project build directory"
  :type 'string)

(defcustom project-build-command "ninja"
  "Default command to build project"
  :type 'string)

(defcustom read-project-compile-commands nil
  "compile-commands reader function"
  :type 'function)

(load-library (f-join langsup-base-path "compile-commands-json"))

(defun bind-read-project-compile-commands ()
  (setq-local read-project-compile-commands
              (if (and (boundp 'project-build-path)
                       (not (null project-build-path)))
                  (make-read-compile-commands-in-dir project-build-path)
                #'read-compile-commands-resolved-by-rtags)))

(defun project-rtags? ()
  (or (not (boundp 'project-build-path))
      (null project-build-path)))

;;;

(require 'flycheck)

(use-package realgud :ensure t :pin melpa)
(use-package rmsbolt :ensure t :pin melpa)
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

(use-package counsel-gtags :ensure t :pin melpa)

(use-package rtags :ensure t :pin melpa
  :config
  (progn (setq rtags-autostart-diagnostics nil)
         (setq rtags-completions-enabled t)))


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
  (rtags-start-process-unless-running))

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
  (bind-read-project-compile-commands)
  (if (project-rtags?)
      (my-c-c++-rtags-hook)
    (my-c-c++-gtags-hook))
  (flycheck-c/c++-clang-and-gcc-setup)
  (setq-local rmsbolt-command
              (compile-commands-json/rmsbolt-command
               read-project-compile-commands (buffer-file-name)))
  (flycheck-mode)
  ;;
  (c-c++-bind-key-map)
  )

(add-hook 'c-mode-local-vars-hook 'my-c-c++-mode-hook2)
(add-hook 'c++-mode-local-vars-hook 'my-c-c++-mode-hook2)


;;; find result executable and run/debug it
(require 'seq)
(use-package levenshtein :ensure t :pin melpa)
(require 'cl)
(use-package f :ensure t)

(defun list-executable-files (dir)
  (seq-filter 'file-executable-p
              (directory-files-recursively
               dir ".*")))

(defun* file-list->distance-alist (fn file-names &key dist-fun)
  (let ((fn* (f-filename fn)))
    (mapcar (lambda (i)
              (cons (funcall (or dist-fun #'levenshtein-distance)
                             fn* (f-filename i))
                    i))
            file-names)))

(defun list-executable-files-and-sort-by (dir file-name)
  (mapcar #'cdr
          (sort
           (file-list->distance-alist
            file-name
            (list-executable-files dir))
           (lambda (x y) (< (car x) (car y))))))

(defun run-command-with (cmd mkcmd-fun run-fun)
  (interactive)
  (let* ((cmd*
          (read-from-minibuffer "Cmd: " (funcall mkcmd-fun cmd))))
    (funcall run-fun cmd*)))


(require 'ivy)

(defun run-executable-by-buffer-name ()
  (interactive)
  (ivy-read "Select executable to run: "
            (list-executable-files-and-sort-by
	     (compile-commands-json/build-dir read-project-compile-commands
                                              (buffer-file-name))
             (buffer-file-name))
            :action (lambda (cmd)
                      (run-command-with cmd
                                        (lambda (cmd)
                                          (format "cd '%s'; %s" (f-dirname cmd) cmd))
                                        #'compile))))

(defun debug-executable-by-buffer-name ()
  (interactive)
  (ivy-read "Select executable to debug: "
            (list-executable-files-and-sort-by
	     (compile-commands-json/build-dir read-project-compile-commands
                                              (buffer-file-name))
             (buffer-file-name))
            :action (lambda (cmd)
                      (run-command-with cmd
                                        (lambda (cmd)
                                          (format "gdb %s" cmd))
                                        #'realgud:gdb))))

(defun c-c++-rmsbolt-this ()
  (interactive)
  (rmsbolt-mode)
  (rmsbolt-compile))


(defun compile-in-project-build-path ()
  (interactive)
  (compile
   (read-from-minibuffer "Cmd: " (format "cd '%s'; %s"
                                         (compile-commands-json/build-dir read-project-compile-commands
                                                                          (buffer-file-name))
                                         project-build-command))))

;;;
(defun rtags-local-defs ()
  (message "Using RTags")
  (define-key c-mode-base-map (kbd "M-.") #'rtags-find-symbol-at-point)
  (define-key c-mode-base-map (kbd "M-,") #'rtags-location-stack-back)
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

    "f" 'clang-format-dwim

    "b" 'compile-in-project-build-path

    "r" '(:ignore t :which-key "run")
    "r r" 'run-executable-by-buffer-name
    "r d" 'debug-executable-by-buffer-name
    "r b" 'c-c++-rmsbolt-this
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

    "f" 'clang-format-dwim

    "b" 'compile-in-project-build-path

    "r" '(:ignore t :which-key "run")
    "r r" 'run-executable-by-buffer-name
    "r d" 'debug-executable-by-buffer-name
    "r b" 'c-c++-rmsbolt-this
    ))

(defun c-c++-bind-key-map ()
  (when (fboundp 'general-create-definer)
    (if (project-rtags?)
        ;; RTags
        (rtags-local-defs)
      ;; GNU Global
      (gtags-local-defs))))


;; EOF
