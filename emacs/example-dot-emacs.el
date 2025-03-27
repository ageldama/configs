;; (setq langsup-base-path (expand-file-name "~/P/configs/emacs/"))
;; (load-file (expand-file-name "~/P/configs/emacs/dot-emacs-2021.el"))

(setq large-file-warning-threshold (* 1024 1024 1024))

;;; minimi
(setq minimi-config-path
      (expand-file-name "~/P/configs/emacs/"))

(add-to-list 'load-path (concat minimi-config-path "/elisp"))

(load-file (concat minimi-config-path
                   "/dot-mini-emacs-2023"))

(let ((l '(
           "exec-path-from-shell.el"
           "feat/direnv.el"
           ;; "feat/pc-bufsw.el"
           ;; "feat/helm.el"
           ;; "feat/helm-swoop.el"
           "feat/browse-kill-ring.el"
	   "feat/company.el"
	   "feat/deadgrep.el"
	   "feat/editorconfig.el"
	   "feat/eldoc.el"
	   "feat/evil-matchit.el"
	   "feat/evil-owl.el"
	   "feat/evil-surround.el"
	   "feat/flycheck.el"
	   ;; "feat/flycheck-compcmdsjson.el"
	   ;; "feat/helpful.el"
	   "feat/hl-todo.el"
	   "feat/magit.el"
	   "feat/markdown-mode.el"
	   ;; "feat/moonshot.el"
	   ;; "feat/multiple-cursors.el"
	   "feat/plantuml.el"
	   "feat/projectile.el"
           ;; "feat/helm-projectile.el"
	   "feat/quelpa.el"
	   ;; "feat/realgud.el"
	   "feat/string-inflection.el"
	   "feat/unfill.el"
	   "feat/vimish-fold.el"
	   "feat/yas.el"
	   "feat/counsel.el"
	   "feat/apheleia.el"
	   "feat/rg.el"
	   ;; "feat/helm-ag.el"
	   "feat/embark.el"
	   "feat/treemacs.el"

	   ;; "auctex.el"
	   ;; "c++-light-2022.el"
	   ;; "clojure.el"
	   ;; "cmake.el"
	   ;; "geiser.el"
	   ;; "golang.el"
	   ;; "golang-light.el"
	   ;; "golang-lsp.el"
	   ;; "golang-lsp2.el"
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
	   ;; "lang-tcl.el"
	   ;; "vtchcc-eglot.el" ; typescript, yaml
	   ;; "json.el"
	   ;; "javascript/js2.el"
	   ;; "javascript/typescript.el"
	   "web.el"
	   ;; "xclip.el"
	   ;; "zig.el"
	   ;; "lsp.el"
	   "eglot.el"
           )))
  (dolist (i l) (load-file (concat minimi-config-path i)))
  ;;
  (def-hydras))




;;; Debian Buster:
;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(when window-system
  (progn
    (setq
     ;; *ageldama/font-fixed-en* "Noto Sans Mono" 
     ;; *ageldama/font-fixed-en* "DejaVu Sans Mono" 
     ;; *ageldama/font-fixed-en* "Anonymous Pro"
     *ageldama/font-fixed-en* "JetBrains Mono"
     ;; *ageldama/font-fixed-en* "Source Code Pro"
     ;; *ageldama/font-fixed-en* "D2Coding" 
     ;; *ageldama/font-fixed-en* "HBIOS-SYS" 
     ;; *ageldama/font-fixed-ko* "나눔고딕코딩"
     ;; *ageldama/font-fixed-ko* "Noto Sans Mono CJK KR"
     *ageldama/font-fixed-ko* "D2Coding"
     ;; *ageldama/font-fixed-ko* "DOSSaemmul"
     ;; *ageldama/font-fixed-ko* "HBIOS-SYS"
     )
    (my-set-fixed-fonts *ageldama/font-fixed-en*
                        *ageldama/font-fixed-ko*)
    (set-face-attribute 'default nil :height 80))


  ;;; NOTE 105, 85, 95?

  ;; (load-theme 'modus-vivendi t)
  ;; (load-theme 'modus-operandi-tinted t)
  (require 'day-and-night)
  (setq *day-and-night/day-theme* 'modus-operandi-tinted)
  (setq *day-and-night/night-theme* 'modus-vivendi-tinted)
  (day-and-night/change-theme-by-time)
  (day-and-night/start-timer 30)
  )

(global-display-line-numbers-mode -1)
(global-hl-line-mode 1)

;; 너무 느리면 끄자.
(when (fboundp 'yas-global-mode)
  (yas-global-mode +1)
  ;; (yas-global-mode -1)
  )

;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))


(add-hook 'c-mode-common-hook
          (lambda () (when (fboundp 'flycheck-mode)
                       (flycheck-mode -1))))


(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))


;; (dolist (cmd '(
;;                "cd %d; rubocop -A"
;;                ))
;;   (cl-pushnew cmd moonshot-runners-preset :test #'string=))

;;;EOF.
