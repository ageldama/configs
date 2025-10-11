;;; -*- mode: emacs-lisp; -*-

(setq default-input-method  "korean-hangul"
      user-full-name        "Jong-Hyouk Yun"
      user-mail-address     "ageldama@gmail.com"
      org-crypt-key         "ageldama@gmail.com"
    )


;;; core:
(require 'cl-lib)

(let ((+root+ (expand-file-name "~/P/configs/emacs")))
  (dolist (p (list +root+
		   (concat +root+ "/boot")))
    (cl-pushnew p load-path :test #'equal)))


(require 'e-boot-common-2025)
(require 'e-core-2025)


;;; align-regexp = "; [^;|.]+$"
(ag-requires
 :tag-:*feats
 ;:compile
 'ag-feat-recentf                  ; dpkg=+
 'ag-feat-savehist                 ; dpkg=+
 'ag-feat-avy                      ; dpkg=elpa-avy
 'ag-feat-ace-window               ; dpkg=elpa-ace-window
 'ag-feat-undo-tree                ; dpkg=elpa-undo-tree
 'ag-feat-diminish                 ; dpkg=elpa-diminish
 'ag-feat-base16-theme             ; dpkg=-
 'ag-feat-modus-themes             ; dpkg=elpa-modus-theme
 ;; 'ag-feat-smart-mode-line       ; dpkg=-
 ;; 'ag-feat-fundamental-mode      ; dpkg=+
 ;; 'ag-feat-ob-plantuml           ; dpkg=+
 ;; 'ag-feat-ob-ditaa              ; dpkg=+
 'ag-feat-pulsar                   ; dpkg=-
 'ag-feat-expand-region            ; dpkg=elpa-expand-region
 'ag-feat-hydra--expand-region     ; dpkg=elpa-expand-region,elpa-hydra
 'ag-feat-evil                     ; dpkg=elpa-evil
 'ag-feat-evil-collection          ; dpkg=-
 ;; 'ag-feat-deadgrep              ; dpkg=-
 'ag-feat-rg                       ; dpkg=elpa-rg
 'ag-feat-eldoc                    ; dpkg=+
 'ag-feat-company                  ; dpkg=elpa-company
 'ag-feat-magit                    ; dpkg=elpa-magit
 'ag-feat-web-mode                 ; dpkg=elpa-web-mode
 'ag-feat-hl-todo                  ; dpkg=elpa-hl-todo
 'ag-feat-markdown-mode            ; dpkg=elpa-markdown-mode
 'ag-feat-projectile               ; dpkg=elpa-projectile
 'ag-feat-flycheck                 ; dpkg=elpa-flycheck
 'ag-feat-ggtags                   ; dpkg=elpa-ggtags
 ;; 'ag-feat-direnv                ; dpkg=-
 ;; 'ag-feat-editorconfig          ; dpkg=elpa-editorconfig
 ;; 'ag-feat-plantuml              ; dpkg=-
 ;; 'ag-feat-helpful               ; dpkg=elpa-helpful
 ;; 'ag-feat-vertico               ; dpkg=elpa-vertico
 ;; 'ag-feat-marginalia            ; dpkg=elpa-marginalia
 ;; 'ag-feat-orderless             ; dpkg=elpa-orderless
 ;; 'ag-feat-consult               ; dpkg=elpa-consult
 'ag-feat-counsel                  ; dpkg=elpa-counsel
 'ag-feat-ivy-rich                 ; dpkg=-
 'ag-feat-ivy-hydra                ; dpkg=-
 'ag-feat-counsel-projectile       ; dpkg=-
 'ag-feat-smex                     ; dpkg=elpa-smex
 'ag-feat-json                     ; dpkg=-
 'ag-feat-toml                     ; dpkg=-
 'ag-feat-yaml                     ; dpkg=-
 'ag-feat-vimish-fold              ; dpkg=elpa-vimish-fold
 'ag-feat-evil-vimish-fold         ; dpkg=-
 'ag-feat-yas                      ; dpkg=elpa-yasnippet-snippets
 ;; 'ag-feat-treemacs              ; dpkg=elpa-treemacs
 ;; 'ag-feat-treemacs-projectile   ; dpkg=elpa-treemacs-projectile
 ;; 'ag-feat-treemacs-evil         ; dpkg=elpa-treemacs-evil
 ;; 'ag-feat-treemacs-magit        ; dpkg=elpa-treemacs-magit
 ;; 'ag-feat-treemacs-icons-dired  ; dpkg=-
 'ag-feat-c                        ; dpkg=+
 ;; 'ag-feat-php                   ; dpkg=+
 ;; 'ag-feat-perl5                 ; dpkg=+
 ;; 'ag-feat-ivy-emoji-maybe       ; dpkg=-
 ;; 'ag-feat-embark                ; dpkg=elpa-embark
 ;; 'ag-feat-embark-consult        ; dpkg=-
 ;; 'ag-feat-multiple-cursors      ; dpkg=-
 ;; 'ag-feat-protobuf-mode         ; dpkg=-
 ;; 'ag-feat-string-inflection     ; dpkg=-
 ;; 'ag-feat-apheleia              ; dpkg=-
 'ag-feat-evil-surround            ; dpkg=-
 'ag-feat-evil-owl                 ; dpkg=-
 'ag-feat-evil-matchit             ; dpkg=-
 ;; 'ag-feat-add-node-modules-path ; dpkg=-
 ;; 'ag-feat-js2-mode              ; dpkg=elpa-js2-mode
 ;; 'ag-feat-sly                   ; dpkg=elpa-sly
 ;; 'ag-feat-slime                 ; dpkg=elpa-slime
 ;; 'ag-feat-eglot                 ; dpkg=+|elpa-eglot
 ;; 'ag-feat-realgud               ; dpkg=-
 ;; 'ag-feat-unfill                ; dpkg=-
 ;; 'ag-feat-exec-path-from-shell  ; dpkg=elpa-exec-path-from-shell
 ;; 'ag-feat-quelpa                ; dpkg=-
 ;; 'ag-feat-zig                   ; dpkg=-
 ;; 'ag-feat-meson                 ; dpkg=-
 ;; 'ag-feat-cmake                 ; dpkg=-
 ;; 'ag-feat-golang-light          ; dpkg=-
 'ag-feat-rainbow-mode             ; dpkg=-
 ;; 'ag-feat-auto-dim-other-buffers   ; dpkg=-
 ;; 'ag-feat-funky-fonts
 'ag-feat-rfc-mode
 )


;;; once all loaded, reinit it:
(require 'ag-reinit)
(ag-reinit/run-all)


;;; treemacs
;; (treemacs-start-on-boot)

;;; evil
(evil-mode +1)


;;;

(defun %emacsrc-look (&optional frame)
  (when (and t (window-system frame))
    ;; "Noto Sans Mono"
    ;; "Anonymous Pro"
    ;; "JetBrains Mono"
    ;; "Source Code Pro"
    ;; "D2Coding"
    ;; "HBIOS-SYS"
    ;; "나눔고딕코딩"
    ;; "Noto Sans Mono CJK KR"
    ;; "DOSSaemmul"
    ;; "HBIOS-SYS"
    (set-frame-font
     ;; "DejaVu Sans Mono"
     "Adwaita Mono"
     )

    (ag-set-fixed-fonts
     ;; "DejaVu Sans Mono"
     "Adwaita Mono"
     "Neo둥근모 Code"
     ;; "D2Coding"
     )

    (ag-set-font-height 104)

    (load-theme 'leuven-dark t)
    ;; (load-theme 'base16-greenscreen t)
    ;; (load-theme 'modus-operandi-tinted t)
    ;; (require 'ag-feat-day-and-night)
    ;; (setq *day-and-night/day-theme* 'modus-operandi)
    ;; (setq *day-and-night/night-theme* 'modus-vivendi)
    ;; (day-and-night/change-theme-by-time)
    ;; (day-and-night/start-timer 30)
    ;; (day-and-night/declare-its-day)
    ;; (day-and-night/declare-its-night)
    ))

(push #'%emacsrc-look after-make-frame-functions)

(%emacsrc-look)






;;;

(global-display-line-numbers-mode -1)
(global-hl-line-mode +1)


;; 생각보다 무거워서 lazy-init + only-once:
(when (and (fboundp 'yas-global-mode) (fboundp 'ag-feat-yas--install-hok))
  (setq ag-feat-yas-global-mode +1)
  (ag-feat-yas--install-hook))


;; (toggle-battery-saving-mode)
;; (add-hook 'prog-mode-hook (lambda () (company-mode -1)))


(when (fboundp 'flycheck-mode)
  (add-hook 'c-mode-common-hook
            (lambda () (flycheck-mode -1))))


(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))


;;; zone
(zone-when-idle 30)


;;; mu4e
(load-file "~/P/v3/+dot+/mu4e/mu4e.el")

;;; ----------------------------------------------------------------------

