


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
   "-aADFhlv --group-directories-first --time-style=long-iso -X"

   dired-guess-shell-alist-user ; those are the suggestions for ! and & in Dired
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open")
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open")
     (".*" "xdg-open"))
   )

  (when (eq system-type 'berkeley-unix)
    (setq insert-directory-program "gls"
          dired-use-ls-dired t
          ;; dired-listing-switches "-al --group-directories-first"
          ))

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



(defun etags+find ()
  (interactive)
  (let* ((cur-dir (if (eq major-mode 'dired-mode)
                      dired-directory default-directory))
         (dir (read-directory-name "In Directory (etags + find): " cur-dir))
         (cmd (read-string "Command: "(format "cd '%s' && find . -type f | xargs etags" dir))))
    (compile cmd)))




(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "C-c t") 'etags+find))




;;;
(provide 'ag-dired)
