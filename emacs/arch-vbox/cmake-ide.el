;;; cmake-ide
(unless (boundp 'spacemacs-version)
  (use-package flycheck :ensure t :pin melpa
    :config (global-flycheck-mode))  ;; 이것만 설치해도, cmake-ide에서 자동으로 체크되는듯.
  )
(progn
  (add-hook 'c-mode-hook 'flycheck-mode)
  (add-hook 'c++-mode-hook 'flycheck-mode)
  )

(use-package flycheck-clang-tidy :ensure t :pin melpa
  :config  (add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup))

(use-package company :ensure t :pin melpa
  :config   (progn (add-hook 'after-init-hook 'global-company-mode)
                   (global-set-key (kbd "C-c \\") 'company-complete-common-or-cycle)
                   (setq company-idle-delay 0)))
(progn
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'company-mode)
  )

(use-package eldoc :ensure t :pin melpa
  :diminish eldoc-mode)

(use-package irony :ensure t :pin melpa
  :config (progn (add-hook 'c++-mode-hook 'irony-mode)
		 (add-hook 'c-mode-hook 'irony-mode)
		 (add-hook 'objc-mode-hook 'irony-mode)
		 (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))

(use-package irony-eldoc :ensure t :pin melpa  ; 이걸로 eldoc.
  :config (add-hook 'irony-mode-hook #'irony-eldoc))

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
