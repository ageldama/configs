

(add-to-list 'auto-mode-alist '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . ruby-mode))



(with-eval-after-load 'eglot
 (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp")))


(use-package rbs-mode :ensure t)

(use-package yari :ensure t)

(use-package inf-ruby :ensure t :pin melpa
  :config
  (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
  ;; (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  ;;
  ;; (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter-and-focus)
  )



(defcustom ri-server-port 8214
  "Port number: `ri --server=${PORT}'."
  :type 'integer
  :group 'ri-server)


(require 'simple)
(require 'browse-url)


(defun ri-server (port browse-p)
  (interactive (list (read-number "Port number: " ri-server-port)
                     (y-or-n-p "Browse the index page?")
                     ))
  (let ((cmd (format "ri --server=%d" port)))
    (async-shell-command cmd (generate-new-buffer-name "*ri server*"))
    (when browse-p
      (browse-url (format "http://localhost:%d" port)))))


(require 'dash)
(require 's)

(defun ri-ruby ()
  (interactive)
  (let* ((ruby-rdoc-list
          (-filter (lambda (s) (and (not (s-starts-with? "#" s))
                                    (not (s-blank? s))))
                   (split-string
                    (shell-command-to-string "ri -T -fmarkdown ruby:")
                    "\n")))
         (selected (completing-read "Select: " ruby-rdoc-list nil t)))
    (message "SEL: %s" selected)
    (let ((buf (generate-new-buffer (format "*rdoc ruby:%s*" selected))))
      (shell-command (format "ri -T -fmarkdown ruby:%s" selected) buf)
      ;;
      (switch-to-buffer-other-window buf)
      (read-only-mode)
      (markdown-mode)
      (view-mode))))





(defun rubocop-auto ()
  (interactive)
  (compile (format "rubocop -a %s" (buffer-file-name))))



(when (fboundp 'defhydra)
  (eval '(defhydra hydra-lang-ruby ()
           "ruby"

           ("f" rubocop-auto "rubocop -a" :exit t)
           ("M-$" ri-server "ri-server" :exit t)
           ("?" yari "ri" :exit t)
           ("M-?" ri-ruby "ri:ruby" :exit t)

           ("SPC" nil)))

  (require 'ag-lang-mode)
  (lang-mode-hydra-set 'ruby-mode-hook 'hydra-lang-ruby/body))




(provide 'ag-feat-ruby-lite)
