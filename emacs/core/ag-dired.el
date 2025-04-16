


(use-package dired
  :ensure nil
  :commands (dired)

  :config

  (setq
   dired-dwim-target t
   dired-deletion-confirmer 'y-or-n-p
   dired-recursive-deletes 'top
   dired-recursive-copies 'always

   dired-listing-switches
   "-aADFhlv --group-directories-first --time-style=long-iso"

   dired-guess-shell-alist-user ; those are the suggestions for ! and & in Dired
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open")
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open")
     (".*" "xdg-open"))
   )
  )


(use-package wdired
  :ensure nil
  :config
  (setq
   wdired-confirm-overwrite t
   wdired-use-interactive-rename t
   )
  )


(use-package image-dired
  :ensure nil
  :commands (image-dired)

  :bind
  ( :map image-dired-thumbnail-mode-map
    ("<return>" . image-dired-thumbnail-display-external))

  :config
  (setq image-dired-thumbnail-storage 'standard)
  (setq image-dired-external-viewer "xdg-open")
  (setq image-dired-thumb-size 80)
  (setq image-dired-thumb-margin 2)
  (setq image-dired-thumb-relief 0)
  (setq image-dired-thumbs-per-row 4))


;;;
(provide 'ag-dired)
