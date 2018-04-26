;;; cmake-ide
(when (boundp 'spacemacs-version)
  (dolist (i '(flycheck-clang-tidy rtags cmake-ide clang-format))
    (add-to-list 'dotspacemacs-additional-packages i)))

(unless (boundp 'spacemacs-version)
  (use-package flycheck :ensure t :pin melpa
    :config (global-flycheck-mode)))
(progn
  (add-hook 'c-mode-hook 'flycheck-mode)
  (add-hook 'c++-mode-hook 'flycheck-mode))

(use-package flycheck-clang-tidy :ensure t :pin melpa
  :config  (add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup))

(use-package company :ensure t :pin melpa
  :config   (progn (add-hook 'after-init-hook 'global-company-mode)
                   (global-set-key (kbd "C-c \\") 'company-complete-common-or-cycle)
                   (setq company-idle-delay 0)))
(progn
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'company-mode))

;; (use-package irony :ensure t :pin melpa
;;   :config (progn (add-hook 'c++-mode-hook 'irony-mode)
;; 		 (add-hook 'c-mode-hook 'irony-mode)
;; 		 (add-hook 'objc-mode-hook 'irony-mode)
;; 		 (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))

;; (use-package irony-eldoc :ensure t :pin melpa  ; 이걸로 eldoc.
;;   :config (add-hook 'irony-mode-hook #'irony-eldoc))

(use-package rtags :ensure t :pin melpa
  :config (progn (setq rtags-autostart-diagnostics t)
                 (setq rtags-completions-enabled t)
                 (require 'company)
                 (push 'company-rtags company-backends)
                 (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
                 (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
                 (add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
                 ;;
                 (define-key c-mode-base-map (kbd "M-.") (function rtags-find-symbol-at-point))
                 (define-key c-mode-base-map (kbd "M-,") (function rtags-find-references-at-point))
                 (define-key c-mode-base-map (kbd "M-;") (function rtags-find-file))
                 (define-key c-mode-base-map (kbd "C-.") (function rtags-find-symbol))
                 (define-key c-mode-base-map (kbd "C-,") (function rtags-find-references))
                 (define-key c-mode-base-map (kbd "C-<") (function rtags-find-virtuals-at-point))
                 (define-key c-mode-base-map (kbd "M-i") (function rtags-imenu))
                 (define-key c-mode-base-map (kbd "C-c <") (function rtags-location-stack-back))
                 ))

(use-package eldoc :ensure t :pin melpa
  :diminish eldoc-mode)

;;; Rtags + Eldoc:
;;; https://github.com/Andersbakken/rtags/issues/987
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

(use-package cmake-ide :ensure t :pin melpa
  :config (progn (require 'rtags) ;; optional, must have rtags installed
		 (cmake-ide-setup)
		 ;;
		 (defun cmake-ide-compile* ()
		   (interactive)
		   (let ((old-pw default-directory))	
		     (cd (cide--build-dir))
		     (call-interactively 'compile)
		     (cd old-pw)))
		 (define-key c-mode-base-map (kbd "C-c b") (function cmake-ide-compile*))))

(when t ;; cmake-ide + gdb.
  (defun cmake-ide-gdb-files-source ()
    (interactive)
    (require 'seq)
    (let ((exec-files   (seq-filter 'file-executable-p 
				    (directory-files-recursively (cide--build-dir) ".*"))))
      `((name . "HELM at the Emacs")
	(candidates . ,exec-files)
	(action . (lambda (sel)
		    (gdb
		     (read-from-minibuffer "Cmd: " (format "%s %s" gud-gdb-command-name sel))))))))
  (defun cmake-ide-helm-run-gdb ()
    (interactive)
    (helm :sources (cmake-ide-gdb-files-source)))
  (define-key c-mode-base-map (kbd "C-c d")
    (function cmake-ide-helm-run-gdb)))

(use-package clang-format :ensure t :pin melpa
  :config
  (defun clang-format-auto ()
    (interactive)
    (if mark-active
      (call-interactively 'clang-format-region)
      (clang-format-buffer)))
  (define-key c-mode-base-map (kbd "C-c C-f") (function clang-format))
  (define-key c-mode-base-map (kbd "C-c f") (function clang-format-auto)))

;; major-mode keys
(when (boundp 'spacemacs-version)
  (dolist (mode-name '(c-mode c++-mode))
    (spacemacs/declare-prefix-for-mode mode-name "mb" "build&cmake")
    (spacemacs/declare-prefix-for-mode mode-name "mr" "rtags")
    (spacemacs/declare-prefix-for-mode mode-name "mf" "formatting")
    (spacemacs/set-leader-keys-for-major-mode mode-name
      ;; Compile, CMake
      "bc" 'cmake-ide-run-cmake
      "bb" 'cmake-ide-compile
      "bB" 'cmake-ide-compile*
      ;; RTags
      "r." 'rtags-find-symbol-at-point
      "r," 'rtags-find-references-at-point
      "r;" 'rtags-find-file
      "rs" 'rtags-find-symbol
      "rr" 'rtags-find-references
      "rv" 'rtags-find-virtuals-at-point
      "ri" 'rtags-imenu
      "r<" 'rtags-location-stack-back
      "rD" 'rtags-dependency-tree
      "rR" 'rtags-references-tree
      "r!" 'rtags-fix-fixit-at-point
      ;; Debugger
      "d" 'cmake-ide-helm-run-gdb
      ;; Formatting
      "ff" 'clang-format-auto
      "fF" 'clang-format
      )))


;; DONE: clang-tidy
;; DONE: run-tests
;; DONE: cmake-ide / specify build-directory?
;; (setq cmake-ide-build-dir "./_build")
;; DONE: cmake-ide / debug-flag?
;; DONE: cmake-ide / use ninja instead of make?
;; (setq cmake-ide-cmake-opts "-DCMAKE_BUILD_TYPE=Debug -GNinja")
;; DONE: ".dir-locals.el"
;; ((nil . ((cmake-ide-build-dir . "./_build")
;;	 (flycheck-clang-tidy-build-path . "_build")
;; 	 (cmake-ide-cmake-opts . "-DCMAKE_BUILD_TYPE=Debug -GNinja"))))


;;; EOF.
