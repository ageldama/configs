;;; slime
(when nil
  (use-package slime :ensure t :pin melpa
    :config (progn
              (setq inferior-lisp-program "/Users/jhyun/local/sbcl-1.2.11-x86-64-darwin/run-sbcl.sh")
              (require 'slime)
              (slime-setup '(slime-fancy)))))

;;; irony
(when nil
  (use-package irony :ensure t :pin melpa
    :config (progn
              ;; If irony server was never installed, install it.
              (unless (irony--find-server-executable)
                (call-interactively #'irony-install-server))
              (add-hook 'c++-mode-hook 'irony-mode)
              (add-hook 'c-mode-hook 'irony-mode)
              ;; Use compilation database first, clang_complete as fallback.
              (setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                              irony-cdb-clang-complete))
              (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))
  ;; I use irony with company to get code completion.
  (use-package company-irony :ensure t :pin melpa
    :config (progn
              (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))
  ;; I use irony with flycheck to get real-time syntax checking.
  (use-package flycheck-irony :ensure t :pin melpa
    :config (progn
              (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))
  ;; Eldoc shows argument list of the function you are currently writing in the echo area.
  (use-package irony-eldoc :ensure t :pin melpa
    :config (progn (add-hook 'irony-mode-hook #'irony-eldoc))))

;;; rdm
;;; http://martinsosic.com/development/emacs/2017/12/09/emacs-cpp-ide.html
(when t
  (use-package rtags :ensure t :pin melpa
    :config
    (progn
      (unless (rtags-executable-find "rc") (error "Binary rc is not installed!"))
      (unless (rtags-executable-find "rdm") (error "Binary rdm is not installed!"))
      ;;
      (define-key c-mode-base-map (kbd "M-.") 'rtags-find-symbol-at-point)
      (define-key c-mode-base-map (kbd "M-,") 'rtags-find-references-at-point)
      (define-key c-mode-base-map (kbd "M-?") 'rtags-display-summary)
      (rtags-enable-standard-keybindings)
      ;;
      (setq rtags-use-helm t)
      ;; Shutdown rdm when leaving emacs.
      ;;(add-hook 'kill-emacs-hook 'rtags-quit-rdm)
      ))
  ;; TODO: Has no coloring! How can I get coloring?
  (use-package helm-rtags :ensure t :pin melpa
    :config
    (progn
      (setq rtags-display-result-backend 'helm)))
  ;; Use rtags for auto-completion.
  (use-package company-rtags :ensure t :pin melpa
    :config
    (progn
      (setq rtags-autostart-diagnostics t)
      (rtags-diagnostics)
      (setq rtags-completions-enabled t)
      (push 'company-rtags company-backends)))
  ;; Live code checking.
  (use-package flycheck-rtags :ensure t :pin melpa
    :config
    (progn
      ;; ensure that we use only rtags checking
      ;; https://github.com/Andersbakken/rtags#optional-1
      (defun setup-flycheck-rtags ()
        (flycheck-select-checker 'rtags)
        (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
        (setq-local flycheck-check-syntax-automatically nil)
        (rtags-set-periodic-reparse-timeout 2.0)  ;; Run flycheck 2 seconds after being idle.
        )
      (add-hook 'c-mode-hook #'setup-flycheck-rtags)
      (add-hook 'c++-mode-hook #'setup-flycheck-rtags))))


;;; CMake
(when t
  (use-package cmake-mode :ensure t :pin melpa))

;;; regex
(when nil
  (use-package regex-tool :ensure t :pin melpa))



;;; Rust
(when nil
  ;; http://julienblanchard.com/2016/fancy-rust-development-with-emacs/
  ;; NOTE: cargo install rustfmt
  ;; NOTE: cargo install racer
  ;; NOTE: git clone git@github.com:rust-lang/rust.git
  (use-package toml-mode :ensure t :pin melpa)
  (use-package rust-mode :ensure t :pin melpa
    :config (add-hook 'rust-mode-hook
                      (lambda ()
                        (local-set-key (kbd "C-c C-c \\") #'rust-format-buffer))))
  (use-package cargo :ensure t :pin melpa
    :config (add-hook 'rust-mode-hook 'cargo-minor-mode))
  (use-package racer :ensure t :pin melpa
    :config (progn
              ;; Rustup binaries PATH
              (setq racer-cmd "~/.cargo/bin/racer")
              ;; Rust source code PATH
              ;; OR rustup component add rust-src
              ;; `rustc --print sysroot`/lib/rustlib/src/rust/src/
              (setq racer-rust-src-path
                    "/Users/jhyun/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"
                    ;;"/home/jyun/local/rust/src"
                    )
              ;;
              (add-hook 'rust-mode-hook #'racer-mode)
              (add-hook 'racer-mode-hook #'eldoc-mode)
              (add-hook 'racer-mode-hook #'company-mode)))
  (use-package flycheck-rust :ensure t :pin melpa
    :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))


;;; Haskell
(when nil
  (use-package intero :ensure t :pin melpa
    :config (progn (add-hook 'haskell-mode-hook 'intero-mode)
                   ;; cabal install stylish-haskell
                   (custom-set-variables '(haskell-stylish-on-save t)))))

;;; Groovy
(when nil
  (use-package groovy-mode :ensure t :pin melpa))

;;; Perl 5
(when t
  (use-package helm-perldoc :ensure t :pin melpa
    :config (helm-perldoc:setup))
  (use-package cpanfile-mode :ensure t :pin melpa)
  (defalias 'perl-mode 'cperl-mode)
  (setq cperl-indent-level 4)
  ;;
  (defun perltidy-command(start end)
    "The perltidy command we pass markers to."
    (shell-command-on-region start 
                             end 
                             "perltidy" 
                             t
                             t
                             (get-buffer-create "*Perltidy Output*")))

  ;; Updated as a dwim.  I like using the existing buffer rather than creating a new buffer.
  (defun perltidy-dwim (arg)
    "Perltidy a region of the entire buffer"
    (interactive "P")
    (let ((point (point)) (start) (end))
      (if (and mark-active transient-mark-mode)
          (setq start (region-beginning)
                end (region-end))
        (setq start (point-min)
              end (point-max)))
      (perltidy-command start end)
      (goto-char point)))
  (add-hook 'cperl-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c t") 'perltidy-dwim)))
  )




;;; EOF.
