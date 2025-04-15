;;; Scrolling

(setq
 ;; Enables faster scrolling. This may result in brief periods of
 ;; inaccurate syntax highlighting, which should quickly self-correct.
 fast-but-imprecise-scrolling t

 ;; Move point to top/bottom of buffer before signaling a scrolling
 ;; error.
 scroll-error-top-bottom t

 ;; Keep screen position if scroll command moved it vertically out of
 ;; the window.
 scroll-preserve-screen-position t

 ;; no "screen recentering", faster & h-scroll-by-1line
 scroll-conservatively 101

 ;; 1. Preventing automatic adjustments to `window-vscroll' for long
 ;; lines.
 ;;
 ;; 2. Resolving the issue of random half-screen jumps during
 ;; scrolling.
 auto-window-vscroll nil

 ;; Number of lines of margin at the top and bottom of a window.
 scroll-margin 0

 ;; Number of lines of continuity when scrolling by screenfuls.
 next-screen-context-lines 0

 ;; Horizontal scrolling
 hscroll-margin 2
 hscroll-step 1
 )



(provide 'ag-scrolling)
