;;; GUI fonts

;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/

(defun ag-set-fixed-fonts (&optional en-fn ko-fn)
  (interactive)
  (let ((en-fn* (or en-fn "DejaVu Sans Mono"))
        (ko-fn* (or ko-fn "NanumGothicCoding")))
    ;; default Latin font (e.g. Consolas)
    ;; but I use Monaco
    (set-frame-font en-fn* t)
    (set-face-attribute 'default nil :family en-fn*)
    ;; default font size (point * 10)
    ;; WARNING!  Depending on the default font,
    ;; if the size is not supported very well, the frame will be clipped
    ;; so that the beginning of the buffer may not be visible correctly.
    (set-face-attribute 'default nil :height 130)
    ;; use specific font for Korean charset.
    ;; if you want to use different font size for specific charset,
    ;; add :size POINT-SIZE in the font-spec.
    (set-fontset-font t 'hangul (font-spec :name ko-fn*))))


(when (and nil window-system)
  (cond
   ;;
   ((member system-type
            '(berkeley-unix gnu/linux darwin))
    (ag-set-fixed-fonts))
   ;;
   ((string-equal system-type "windows-nt")
    (set-face-attribute 'default nil :font "Consolas-11"))
   (t :unknown)))



(defun ag-set-font-height (ht)
  (interactive)
  (when (window-system)
    (set-face-attribute 'default nil :height ht)))




;;;
(provide 'ag-font)
