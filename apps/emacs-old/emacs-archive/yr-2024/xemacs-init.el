;;; ~/.xemacs/init.el :

;;;; [2023-01-31]:
;;;;  MULE-UCS이 불완전해서, 종종 UTF-8 문서도 깨먹으니 사용에 주의.

(setq user-full-name    "Jong-Hyouk Yun")
(setq user-mail-address "ageldama@gmail.com")


(require 'un-define)

(set-language-environment     "English")
(prefer-coding-system         'utf-8)
;;(set-selection-coding-system  'utf-8)
(set-default-coding-systems   'utf-8)
(set-terminal-coding-system   'utf-8)
(set-keyboard-coding-system   'utf-8)
(setq                         locale-coding-system 'utf-8)


(setq default-input-method   "korean-hangul")




(setq-default indent-tabs-mode nil)

;;; (setq tab-stop-list (number-sequence 2 200 2))
;;; seq  -s" " 2 2 200

(setq-default tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34
36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80
82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 112 114 116 118 120
122 124 126 128 130 132 134 136 138 140 142 144 146 148 150 152 154
156 158 160 162 164 166 168 170 172 174 176 178 180 182 184 186 188
190 192 194 196 198 200))

(setq-default tab-width 2)
;;(setq indent-line-function 'insert-tab)


;;(if (fboundp 'global-font-lock-mode)
;;    (global-font-lock-mode 1)        ; GNU Emacs
;; XEmacs
;; (add-hook 'find-file-hook #'font-lock-mode)

(font-lock-mode 'font)
(setq font-lock-auto-fontify t)


;;;; https://wiki.kldp.org/wiki.php/XEmacs-HOWTO :

;; 마우스 휠 설정
(global-set-key [mouse-4] 'scroll-down)
(global-set-key [mouse-5] 'scroll-up)



;; (custom-set-faces
;; '(default ((t (:foreground "gray80" :background "black" :size "15" :family "Fixed"))) t)



;; 폰트 : (TIP) xfontsel ?
(set-face-font
     'default
     '("-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*")
     'prepend)

(set-face-font
      'default
      '("-*-dotum-medium-r-normal--14-*-*-*-*-*-*-*")
      'global
      '(mule-fonts)
      'prepend)




(add-hook 'find-file-hooks
          'turn-on-auto-fill)




;;;

(custom-set-variables
 '(blink-cursor-mode t t)
 '(column-number-mode t)
 '(line-number-mode t)
 '(paren-mode (quote paren) t)
 '(toolbar-visible-p nil))
(custom-set-faces)

;;;EOF

