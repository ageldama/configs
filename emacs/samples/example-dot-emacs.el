
(setq default-input-method  "korean-hangul"
      user-full-name        "Jong-Hyouk Yun"
      user-mail-address     "ageldama@gmail.com"
      org-crypt-key         "ageldama@gmail.com"
    )

(cl-pushnew "~/P/configs/emacs" load-path :test #'equal)

(require 'e-2025)

(require 'ag-feat-evil-collection) ; dpkg=-
(require 'ag-feat-deadgrep) ; dpkg=-
(require 'ag-feat-eldoc)    ; dpkg=-
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
;; (require 'ag-feat-helpful)  ; dpkg=-
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
(require 'ag-feat-treemacs) ; dpkg=elpa-treemacs
(require 'ag-feat-treemacs-projectile)   ; dpkg=elpa-treemacs-projectile
(require 'ag-feat-treemacs-evil)         ; dpkg=elpa-treemacs-evil
(require 'ag-feat-treemacs-magit)        ; dpkg=elpa-treemacs-magit
(require 'ag-feat-treemacs-icons-dired)  ; dpkg=-
;; (require 'ag-feat-perl5) ; dpkg=-
(require 'ag-feat-ivy-emoji-maybe) ; dpkg=-
(require 'ag-feat-embark) ; dpkg=-
(require 'ag-feat-multiple-cursors) ; dpkg=-


;;; once all loaded, rebuild it:

(require 'ag-hydra--main)
(def-hydras)

;;; treemacs
(treemacs-start-on-boot)

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
  (require 'day-and-night)
  (setq *day-and-night/day-theme* 'modus-operandi)
  (setq *day-and-night/night-theme* 'modus-vivendi)
  ;; (day-and-night/change-theme-by-time)
  ;; (day-and-night/start-timer 30)
  (day-and-night/declare-its-day)
  ;; (day-and-night/declare-its-night)
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

;;; TEMP



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(multiple-cursors ivy-emoji treemacs-icons-dired treemacs-magit treemacs-evil treemacs-projectile treemacs evil-vimish-fold toml-mode json-mode ivy-rich counsel-projectile ivy-hydra helpful plantuml-mode wgrep-deadgrep deadgrep evil-collection yasnippet-snippets writeroom-mode which-key wgrep web-mode vimish-fold vertico use-package undo-tree smex smart-mode-line projectile org-contrib modus-themes markdown-mode marginalia magit hydra htmlize hl-todo flycheck expand-region exec-path-from-shell evil eshell-up embark editorconfig diminish counsel consult company ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
