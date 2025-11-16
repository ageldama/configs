(use-package modern-cpp-font-lock :ensure t :pin melpa
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(use-package counsel-gtags :ensure t :pin melpa
  :config
  (add-hook 'c-mode-hook 'counsel-gtags-mode)
  (add-hook 'c++-mode-hook 'counsel-gtags-mode)

  (with-eval-after-load 'counsel-gtags
    (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
    (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
    (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
    (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
    (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)))

(use-package realgud :ensure t :pin melpa)
(use-package rmsbolt :ensure t :pin melpa)
(use-package cmake-mode :ensure t :pin melpa)

;;; flycheck + clang-tidy.
(use-package flycheck-clang-tidy :ensure t :pin melpa)

(load-library (f-join langsup-base-path "compile-commands-json"))

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


;; TODO: select build-path for `flycheck-clang-tidy-build-path`?

;; (use-package flycheck-clangcheck :ensure t :pin melpa)

(use-package clang-format :ensure t :pin melpa
  :config
  (defun clang-format-dwim ()
    (interactive)
    (if mark-active
        (call-interactively #'clang-format-region)
      (clang-format-buffer))))

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


;;;
(when (fboundp 'general-create-definer)
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

    "r" '(:ignore t :which-key "run")
    "r r" 'run-executable-by-buffer-name
    "r d" 'debug-executable-by-buffer-name
    "r b" 'c-c++-rmsbolt-this
    ))

;;;EOF.
