
(require 'find-dired)
(require 'files)
(require 'files-x)
(require 'display-line-numbers)
(require 'whitespace)
(require 'server)
(require 'zone)
(require 'menu-bar)
(require 'xref)
(require 'eshell)
(require 'simple)

(require 'hydra)
(require 's)
(require 'counsel)
(require 'writeroom-mode)
(require 'org-agenda)
(require 'avy)
(require 'undo-tree)
(require 'projectile)

(require 'ag-el)
(require 'ag-gc)
(require 'ag-battery-saving-mode)
(require 'ag-evil)
(require 'ag-diary-impl)
(require 'ag-diary)
(require 'ag-mini-git)
(require 'ag-compile)



(defun def-hydras ()

  (defhydra hydra-files (:exit t)
    ("n" find-name-dired "dired-by-name")

    ("M-s f" (lambda () (interactive)
               (find-file (s-concat "/sudo:root@localhost:" (or (buffer-file-name) "/"))))
     "sudo:file")

    ("M-s d" (lambda () (interactive)
               (find-file (s-concat "/sudo:root@localhost:"
                                    (file-name-directory (or (buffer-file-name) "/")))))
     "sudo:dired")

    ("M-l f" find-file-literally "file-lit")
    ("M-l c" (lambda () (interactive)
               (find-file-literally (buffer-file-name)))
     "cur-lit")

    ("z" counsel-fzf "fzf")

    ("M-w" buffer-path-and-line-col "copy-path-linum"))


  (defhydra hydra-local-vars (:exit t)
    ("d"  add-dir-local-variable  "dir-local")
    ("f"  add-file-local-variable "file-local")
    ("p"  add-file-local-variable-prop-line "prop-line"))


  (eval
   `(defhydra hydra-misc-toggles (:exit t)
      "toggles"
      ("l" display-line-numbers-mode "linum")
      ("s" global-whitespace-mode "whitespaces")
      ("M-s" server-start "emacs-server")
      ("z" zone "zone")
      ("G" my-gc-toggle-timer "gc-timer")
      ("b" toggle-battery-saving-mode "battery-saving")
      ,@(when (fboundp 'writeroom-mode)
          '(("w" writeroom-mode "writeroom")))
      (":" toggle-evil-mode "evil")))


  (defhydra hydra-org (:exit t)
    ("a" org-agenda "org-agenda")
    ("d" diary/new-or-open-org-file "diary" )
    ("m" diary/new-or-open-memo "memo" )
    ("p" v3/open-plan "plan" ))


  (defhydra hydra-git (:exit t)
    ("w" mini-git/gwip "gwip" )
    ("a" mini-git/add "add" )
    ("s" mini-git/status "status" )
    ("p" mini-git/push "push" )
    ("F" mini-git/pull "pull" )
    ("R" mini-git/remote-v "remote-v" )
    )


  (eval
   `(defhydra hydra-mini (:exit t) ;;(global-map "<f12>" :exit t)
      "minimi"

      ("<SPC>" avy-goto-char-timer "avy")
      (";" avy-resume "avy-resume")

      ("`" menu-bar-open "menu-bar" )

      ,@(when (fboundp 'embark-act)
          '(("<tab>" embark-act "embark" )))

      ,@(when (fboundp 'helm-do-grep-ag)
          '(("\\" helm-do-grep-ag "helm-do-grep-ag" )))

      ("." xref-find-definitions "xref-def")

      ;; ,@(when (fboundp 'helm-resume)
      ;;     '(("," helm-resume "helm-resume" )))

      ;; ,@(when (fboundp 'helm-bookmarks)
      ;;     '(("B" helm-bookmarks "bookmks" )))

      ;; ,@(when (fboundp 'counsel-bookmark)
      ;;     '(("B" counsel-bookmark "bookmks" )))

      ;; ,@(when (fboundp 'helm-imenu)
      ;;     '(("I" helm-imenu "imenu" )))

      ,@(when (fboundp 'counsel-imenu)
          '(("C-i" counsel-imenu "imenu" )))

      ,@(when (fboundp 'helm-all-mark-rings)
          '(("R" helm-all-mark-rings "markring" )))

      ,@(when (fboundp 'counsel-mark-ring)
          '(("R" counsel-mark-ring "markring" )))

      ("b" (lambda () (interactive)
             (if (fboundp 'helm-buffers-list)
                 (helm-buffers-list)
               ;; else
               (ibuffer)))
       "buf")

      ("o" hydra-org/body "org")

      ("f" hydra-files/body "files" )

      ("u" undo-tree-visualize "undo-tree" )

      ,@(when (fboundp 'magit-status)
          '(("g" magit-status "magit" )))

      ("G" hydra-git/body "git")

      ("$" eshell "eshell")

      ("t" tab/hydra/body "tabs")

      ("C-$" (lambda () (interactive) (ansi-term shell-file-name)) "term")

      ("k" (lambda () (interactive)
             (cond ((fboundp 'counsel-yank-pop) (counsel-yank-pop))
                   ((fboundp 'helm-show-kill-ring) (helm-show-kill-ring))
                   ((fboundp 'browse-kill-ring) (browse-kill-ring))
                   (t (yank-pop))))
       "yank-pop")

      ("C-k" kill-current-buffer "kill-cur-buf" )

      ,@(when (fboundp 'counsel-recentf)
          '(("r" counsel-recentf "recentf" )))

      ("-" hydra-misc-fns/body "misc-fns" )

      ("'" hydra-misc-toggles/body "toggles" )

      ,@(when (fboundp 'hydra-moonshot/body)
          '(("x" hydra-moonshot/body "moonshot" )))

      ,@(when (fboundp 'hydra-string-inflection/body)
          '(("M-i" hydra-string-inflection/body
             "infl.")))

      ,@(when (fboundp 'hydra-multiple-cursors/body)
          '(("M-c" hydra-multiple-cursors/body "mcurs" )))

      ,@(when (fboundp 'hydra-yas/body)
          '(("y" hydra-yas/body "yas" )))

      ,@(when (fboundp 'hydra-flycheck/body)
          '(("M-c" hydra-flycheck/body "flychk" )))

      ("M-v" hydra-local-vars/body "local-vars" )

      ,@(cond ((and (fboundp 'projectile-mode) (fboundp 'counsel-projectile))
               '(("p" counsel-projectile "prj" )))

              ((and (fboundp 'projectile-mode) (fboundp 'helm-projectile))
               '(("p" helm-projectile "projectile" )))

               (t '(("p" projectile-find-file "prj" ))))

      ("P" projectile-commander "prj-cmdr" )

      ("w" avy-goto-word-1 "goto-word")
      ("l" avy-goto-line "goto-line")

      ("C-r" recompile-showing-compilation-window "recompile")

      ,@(when (fboundp 'hydra-expand-region/body)
          '(("=" hydra-expand-region/body "exp-region")))

      ,@(when (fboundp 'eglot)
          '(("e" hydra-eglot/body "eglot")))

          ))

  (defhydra hydra-misc-fns ()
    "
Misc:^^
--------------------------
_p_ : list-proc
_b_ : bookmarks
_d_ : search sdcv
_s_ : del-trail-ws
_G_ : gc

_SPC_ : cancel
"
    ("p"  counsel-list-processes :exit t)
    ("b"  counsel-bookmark :exit t)
    ("d"  sdcv-search-input :exit t)
    ("s"  delete-trailing-whitespace :exit t)
    ("G"  garbage-collect :exit t)

    ("SPC" nil))

  ) ;; def-hydras



(require 'ag-reinit)

(ag-reinit/add-as-interactive (def-hydras))



;;;
(provide 'ag-hydra--main)
