(require 'flycheck)

(load-library (f-join langsup-base-path "compile-commands-json"))

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


;;; flycheck gcc/clang fixes
(defun flycheck-c/c++-clang-or-gcc-by-project-build-path ()
  (interactive)
  (message "bound? %S" (boundp 'project-build-path))
  (when (boundp 'project-build-path)
    (message "project-build-path -- %S" project-build-path)
    (let ((inc-dirs  (compile-commands-json/include-dirs project-build-path)))
      (message "%S" inc-dirs)
      (setq-local flycheck-clang-include-path inc-dirs)
      (setq-local flycheck-gcc-include-path inc-dirs))))

(add-hook 'hack-local-variables-hook 'my-hack-local-vars-mode-hook)

(defun my-hack-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

(defun my-c-c++-mode-hook2 ()
  (interactive)
  ;; TODO: (setq flycheck-disabled-checkers '(c/c++-clang c/c++-gcc c/c++-cppcheck))
  ;; TODO: (flycheck-select-checker 'c/c++-clang-tidy)
  (flycheck-c/c++-clang-or-gcc-by-project-build-path)
  (when (boundp 'project-build-path)
    (setq-local rmsbolt-command
                (compile-command-json/rmsbolt-command
                 project-build-path (buffer-file-name))))
  (flycheck-mode))

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
            (list-executable-files-and-sort-by project-build-path (buffer-name))
            :action (lambda (cmd)
                      (run-command-with cmd
                                        (lambda (cmd)
                                          (format "cd '%s'; %s" (f-dirname cmd) cmd))
                                        #'compile))))
(defun debug-executable-by-buffer-name ()
  (interactive)
  (ivy-read "Select executable to debug: "
            (list-executable-files-and-sort-by project-build-path (buffer-name))
            :action (lambda (cmd)
                      (run-command-with cmd
                                        (lambda (cmd)
                                          (format "gdb %s" cmd))
                                        #'realgud:gdb))))

(defun c-c++-rmsbolt-this ()
  (interactive)
  (rmsbolt-mode)
  (rmsbolt-compile))


(defcustom project-build-path nil
  "Directory where your `compile_commands.json` is placed"
  :type 'string)

(defcustom project-build-command "ninja"
  "Default command to build project"
  :type 'string);

(defun compile-in-project-build-path ()
  (interactive)
  (compile
   (read-from-minibuffer "Cmd: " (format "cd '%s'; %s"
                                         (f-expand project-build-path)
                                         project-build-command))))

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

    "b" 'compile-in-project-build-path

    "r" '(:ignore t :which-key "run")
    "r r" 'run-executable-by-buffer-name
    "r d" 'debug-executable-by-buffer-name
    "r b" 'c-c++-rmsbolt-this
    ))


;; EOF
