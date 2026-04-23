(use-package modus-themes :ensure t :pin melpa)

(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)

  ;; :bind
  ;; (("<f5>" . modus-themes-rotate)
  ;;  ("C-<f5>" . modus-themes-select)
  ;;  ("M-<f5>" . modus-themes-load-random))

  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)

  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  ;;(modus-themes-load-theme 'ef-orange)
  (modus-themes-load-random)
  )


(when (fboundp 'defhydra)
  (eval '(progn
           (defhydra hydra-modus-themes (:color green)
             "modus-themes"

             ("r" modus-themes-rotate "rotate")
             ("s" modus-themes-select "select" :exit t)
             ("RET" modus-themes-load-random "random" )

             ("SPC" nil))

           (add-to-list 'hydra-mini/misc/++extras
                        '("@"  hydra-modus-themes/body "themes" :exit t)))))




(provide 'ag-feat-modus-themes)
