
(when (equal 'x (window-system))

(progn
  (set-frame-font
   ;; "-adobe-helvetica-medium-r-normal--14-140-75-75-p-77-iso8859-1"
   ;; "-sony-fixed-medium-r-normal--16-120-100-100-c-80-iso8859-1"
   ;; "-b&h-lucidabright-medium-r-normal--17-120-100-100-p-96-iso8859-1"
   ;; "-b&h-lucidabright-medium-r-normal--14-140-75-75-p-80-iso8859-1"
   ;; "r16"
   ;; "DejaVu Sans Mono-10"
   ;; "9x15"
   ;; "12x24"
   "fixed-12"
   ;; "-urw-nimbus mono l-regular-r-normal--16-0-0-0-p-0-iso8859-1"
   ;; "-schumacher-clean-medium-r-normal--16-0-75-75-c-0-iso10646-1-irv"
   )

  (set-face-font 'default
                 ;; "DejaVu Sans Mono-10"
                 ;; "-sony-fixed-medium-r-normal--16-120-100-100-c-80-iso8859-1"
                 "fixed-12"
                 )

  (set-fontset-font t 'hangul
                    ;; "-narae-pinetree.precomposed-medium-r-normal--18-180-75-75-p-120-ksc5601.1987-0"
                    ;; "-hanyang-kodig-medium-r-normal--12-120-72-72-c-120-ksc5601.1987-0"
                    ;; "-hanyang-myeongjo-medium-r-normal--14-140-72-72-c-140-ksc5601.1987-0"
                    ;; "-kaist-newmj-medium-r-normal--16-160-75-75-c-160-ksc5601.1987-0"
                    "-daewoo-mincho-medium-r-normal--*-*-*-*-c-*-ksc5601.1987-0"
                    ;; "-narae-pinetree.precomposed-medium-r-normal--14-140-75-75-p-100-ksc5601.1987-0"
                    )
  ))

  ;; (set-face-attribute t 'default "DejaVu Sans Mono")
  ;; (set-face-font 'default "Dejavu Sans Mono-9")
  ;; (set-face-font 'default "12x24")


  ;; (set-face-font 'default "-schumacher-clean-medium-r-normal--16-160-75-75-c-80-iso646.1991-irv")
  ;; (set-face-attribute 'default nil (font-spec :family "Nimbus Sans Mono"))



;; 한글 예시. Ll1| 0Oo@ [] {} 아침 일찍 구름 낀 백제성을 떠나.
;; NOTE: 화면이 C-p, C-n 등이 느리면 /D2Coding/, 괜찮으면 /Noto Sans Mono CJK/






(provide 'ag-feat-funky-fonts)
