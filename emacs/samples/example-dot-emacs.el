
(setq default-input-method  "korean-hangul"
      user-full-name        "Jong-Hyouk Yun"
      user-mail-address     "ageldama@gmail.com"
      org-crypt-key         "ageldama@gmail.com"
    )

(cl-pushnew "~/P/configs/emacs" load-path :test #'equal)

(require 'e-2025)

(require 'ag-evil-collection)


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
    ;;(set-face-attribute 'default nil :height 80)
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



