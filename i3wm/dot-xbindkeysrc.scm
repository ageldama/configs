(use-modules (ice-9 pretty-print))


(define key+cmds
  `(
    ;; EX-G pro 유무선 하이스펙 트랙볼 마우스 M-XPT1MRBK
    (("b:6")  . "xdotool key Prior") ; wheel <-
    (("b:7")  . "xdotool key Next")  ; wheel ->
    (("b:10") . "xdotool key Next")
    (("b:11") . "xdotool key Prior")
    (("b:12") . "xdotool key Next")

    ;;
    ;;((Mod4 Return)  . "x-terminal-emulator")
    ;;((Mod4 r)       . "gmrun")
    ((Mod4 d)       . "rofi -show")
    ((Mod4 Tab)     . "rofi -show windowcd")
    ((Mod4 Escape)  . "xscreensaver-command -lock")
    ((Mod4 p)       . "gnome-screenshot")
    ((Mod4 Shift p) . "gnome-screenshot -i")
    ((Mod4 e)       . "xdg-open $HOME")
    ((Mod4 Shift e) . "x-terminal-emulator -e mc")

    ((Mod4 Shift w) . "hsetroot-solid.pl")
    ((Mod4 w)       . "wg.pl")

    ((Mod4 F8)      . "sh -c 'notify-send \"$(uptime) // $(date)\"'")
    ((Mod4 F10)     . "pavucontrol")

    ((Mod4 F9)       . "rofi-toggles.sh")
    ((Mod4 Shift F9) . "xscreensaver-toggle.pl; kill -USR1 $(pidof redshift)")

    ;; ((Mod4 F1)      . ,(lambda () (run-command "notify-send foobar")))
    ))


(call-with-output-string (lambda (out) (pretty-print key+cmds out)))


(for-each (lambda (k+cmd)
            (let ((k (car k+cmd))
                  (cmd (cdr k+cmd)))
              ;;(format #t "~a str?~a proc?~a~%" cmd (procedure? cmd) (string? cmd))
              (if (string? cmd)
                  (xbindkey (car k+cmd) (cdr k+cmd))
                  ;; else
                  (xbindkey-function k cmd)
                  )))
          key+cmds)


;;;



;;;EOF.
