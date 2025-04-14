
(setq default-input-method  "korean-hangul"
      user-full-name        "Jong-Hyouk Yun"
      user-mail-address     "ageldama@gmail.com"
      org-crypt-key         "ageldama@gmail.com"
    )

(cl-pushnew "~/P/configs/emacs" load-path :test #'equal)

(require 'e-2025)

(require 'ag-feat-avy) ;; dpkg=elpa-avy
(require 'ag-feat-ace-window) ;; dpkg=elpa-ace-window
(require 'ag-feat-undo-tree) ;; dpkg=elpa-undo-tree
(require 'ag-feat-diminish)  ;; dpkg=elpa-diminish
(require 'ag-feat-modus-themes) ;; dpkg=elpa-modus-theme
;; (require 'ag-feat-smart-mode-line) ;; dpkg=-
;; (require 'ag-feat-fundamental-mode) ;; dpkg=+
(require 'ag-feat-ob-plantuml) ;; dpkg=+
(require 'ag-feat-ob-ditaa) ;; dpkg=+
(require 'ag-feat-expand-region) ; dpkg=elpa-expand-region
(require 'ag-feat-hydra--expand-region) ; dpkg=elpa-expand-region,elpa-hydra
(require 'ag-feat-evil) ; dpkg=elpa-evil
(require 'ag-feat-evil-collection) ; dpkg=-
(require 'ag-feat-deadgrep) ; dpkg=-
(require 'ag-feat-eldoc)    ; dpkg=+
(require 'ag-feat-company)  ; dpkg=elpa-company
(require 'ag-feat-magit)    ; dpkg=elpa-magit
(require 'ag-feat-web-mode) ; dpkg=elpa-web-mode
(require 'ag-feat-hl-todo)  ; dpkg=elpa-hl-todo
(require 'ag-feat-markdown-mode) ; dpkg=elpa-markdown-mode
(require 'ag-feat-projectile)    ; dpkg=elpa-projectile
(require 'ag-feat-flycheck)      ; dpkg=elpa-flycheck
;; (require 'ag-feat-direnv)     ; dpkg=-
;; (require 'ag-feat-editorconfig) ; dpkg=elpa-editorconfig
;; (require 'ag-feat-plantuml)     ; dpkg=-
;; (require 'ag-feat-helpful)  ; dpkg=elpa-helpful
(require 'ag-feat-counsel)  ; dpkg=elpa-counsel
;; (require 'ag-feat-ivy-rich)  ; dpkg=-
;; (require 'ag-feat-ivy-hydra)  ; dpkg=-
;; (require 'ag-feat-counsel-projectile) ; dpkg=-
;; (require 'ag-feat-json) ; dpkg=-
;; (require 'ag-feat-toml) ; dpkg=-
;; (require 'ag-feat-yaml) ; dpkg=-
(require 'ag-feat-vimish-fold) ; dpkg=elpa-vimish-fold
;; (require 'ag-feat-evil-vimish-fold) ; dpkg=-
(require 'ag-feat-yas) ; dpkg=elpa-yasnippet-snippets
;; (require 'ag-feat-treemacs) ; dpkg=elpa-treemacs
;; (require 'ag-feat-treemacs-projectile)   ; dpkg=elpa-treemacs-projectile
;; (require 'ag-feat-treemacs-evil)         ; dpkg=elpa-treemacs-evil
;; (require 'ag-feat-treemacs-magit)        ; dpkg=elpa-treemacs-magit
;; (require 'ag-feat-treemacs-icons-dired)  ; dpkg=-
;; (require 'ag-feat-perl5) ; dpkg=+
(require 'ag-feat-ivy-emoji-maybe) ; dpkg=-
(require 'ag-feat-embark) ; dpkg=elpa-embark
;; (require 'ag-feat-multiple-cursors) ; dpkg=-
;; (require 'ag-feat-protobuf-mode) ; dpkg=-
;; (require 'ag-feat-string-inflection) ; dpkg=-
;; (require 'ag-feat-apheleia) ; dpkg=-
;; (require 'ag-feat-evil-surround) ; dpkg=-
(require 'ag-feat-evil-owl) ; dpkg=-
;; (require 'ag-feat-evil-matchit) ; dpkg=-
;; (require 'ag-feat-add-node-modules-path) ; dpkg=-
;; (require 'ag-feat-js2-mode) ; dpkg=elpa-js2-mode
;; (require 'ag-feat-eglot) ; dpkg=+|elpa-eglot
;; (require 'ag-feat-realgud) ; dpkg=-
;; (require 'ag-feat-unfill) ; dpkg=-
;; (require 'ag-feat-exec-path-from-shell) ; dpkg=elpa-exec-path-from-shell
;; (require 'ag-feat-quelpa) ; dpkg=-
;; (require 'ag-feat-zig) ; dpkg=-
;; (require 'ag-feat-meson) ; dpkg=-
;; (require 'ag-feat-cmake) ; dpkg=-
;; (require 'ag-feat-golang-light) ; dpkg=-


;;; once all loaded, reinit it:
(require 'ag-reinit)
(ag-reinit/run-all)


;;; treemacs
(treemacs-start-on-boot)

;;; evil
;; (evil-mode +1)

;;;

(when window-system
  (progn
    (setq
     ;; *ageldama/font-fixed-en* "Noto Sans Mono"
     *ageldama/font-fixed-en* "DejaVu Sans Mono"
     ;; *ageldama/font-fixed-en* "Anonymous Pro"
     ;; *ageldama/font-fixed-en* "JetBrains Mono"
     ;; *ageldama/font-fixed-en* "Source Code Pro"
     ;; *ageldama/font-fixed-en* "D2Coding"
     ;; *ageldama/font-fixed-en* "HBIOS-SYS"
     ;; *ageldama/font-fixed-ko* "나눔고딕코딩"
     ;; *ageldama/font-fixed-ko* "Noto Sans Mono CJK KR"
     *ageldama/font-fixed-ko* "D2Coding"
     ;; *ageldama/font-fixed-ko* "DOSSaemmul"
     ;; *ageldama/font-fixed-ko* "HBIOS-SYS"
     )
    (ag-set-fixed-fonts *ageldama/font-fixed-en*
                        *ageldama/font-fixed-ko*)
    (set-face-attribute 'default nil :height 88)
    )

  ;; (load-theme 'modus-vivendi t)
  ;; (load-theme 'modus-operandi-tinted t)
  (require 'ag-feat-day-and-night)
  (setq *day-and-night/day-theme* 'modus-operandi)
  (setq *day-and-night/night-theme* 'modus-vivendi)
  ;; (day-and-night/change-theme-by-time)
  ;; (day-and-night/start-timer 30)
  (day-and-night/declare-its-day)
  ;; (day-and-night/declare-its-night)
  )

(global-display-line-numbers-mode -1)
(global-hl-line-mode +1)

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


;;; ----------------------------------------------------------------------

