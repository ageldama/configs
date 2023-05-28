;; (setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))
;; (load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))

;;; minimi
(setq minimi-config-path
      (expand-file-name "~/P/configs/emacs/"))

(load-file (concat minimi-config-path
                   "/dot-mini-emacs-2023"))

(let ((l '(
	   ;; "feat/company.el"
	   ;; "feat/deadgrep.el"
	   ;; "feat/editorconfig.el"
	   ;; "feat/eldoc.el"
	   ;; "feat/evil-matchit.el"
	   ;; "feat/evil-owl.el"
	   ;; "feat/evil-surround.el"
	   ;; "feat/flycheck.el"
	   ;; "feat/helpful.el"
	   ;; "feat/hl-todo.el"
	   ;; "feat/magit.el"
	   ;; "feat/markdown-mode.el"
	   ;; "feat/moonshot.el"
	   ;; "feat/multiple-cursors.el"
	   ;; "feat/plantuml.el"
	   ;; "feat/projectile.el"
	   ;; "feat/quelpa.el"
	   ;; "feat/realgud.el"
	   ;; "feat/string-inflection.el"
	   ;; "feat/unfill.el"
	   ;; "feat/vimish-fold.el"
	   ;; "feat/yas.el"

	   ;; "auctex.el"
	   ;; "c++-light-2022.el"
	   ;; "clojure.el"
	   ;; "cmake.el"
	   ;; "geiser.el"
	   ;; "golang.el"
	   ;; "golang-light.el"
	   ;; "golang-lsp.el"
	   ;; "goog-c-style.el"
	   ;; "lsp-cpp-ccls.el"
	   ;; "lsp-cpp-clangd.el"
	   ;; "lsp-rust-rls.el"
	   ;; "meson.el"
	   ;; "mini-slime.el"
	   ;; "ocaml.el"
	   ;; "org-more.el"
	   ;; "org-roam.el"
	   "perl5.el"
	   ;; "proto+grpc.el"
	   ;; "ruby.el"
	   ;; "rust.el"
	   ;; "slime.el"
	   ;; "sly.el"
	   ;; "tcl.el"
	   ;; "web.el"
	   ;; "xclip.el"
	   ;; "zig.el"
           )))
  (dolist (i l) (load-file (concat minimi-config-path i)))
  ;;
  (def-hydras))




;;; Debian Buster:
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(when window-system
  (progn
    (setq *ageldama/font-fixed-en* "DejaVu Sans Mono" 
          *ageldama/font-fixed-ko* "나눔고딕코딩" )
    (my-set-fixed-fonts))

  (set-face-attribute 'default nil :height 125)
  ;;; NOTE 105, 85?

  ;; (load-theme 'modus-vivendi t)
  (load-theme 'modus-operandi-tinted t)
  )


;; 너무 느리면 끄자.
(when (fboundp 'yas-global-mode)
  (yas-global-mode +1)
  ;; (yas-global-mode -1)
  )

;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))


(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))


;; (dolist (cmd '(
;;                "cd %d; rubocop -A"
;;                ))
;;   (cl-pushnew cmd moonshot-runners-preset :test #'string=))

;;;EOF.
