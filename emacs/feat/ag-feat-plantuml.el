
;;; PlantUML
(use-package plantuml-mode :ensure t :pin melpa

  ;; :config
  ;; (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")

  ;; (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  (append org-babel-load-languages '((plantuml . t))))

  ;; (setq org-confirm-babel-evaluate nil)

  ;; (add-hook 'org-babel-after-execute-hook
  ;;           (lambda ()
  ;;             (when org-inline-image-overlays
  ;;               (org-redisplay-inline-images))))

  ;; TODO C-c C-,
  ;; <u"<TAB>"
  ;; (add-to-list 'org-structure-template-alist
  ;;              '("u" "#+BEGIN_SRC plantuml :file ?.png
  ;;                   \nskinparam monochrome true
  ;;                   \n#+END_SRC"))
  )


(require 'ag-el)
(require 'f)
(require 'ob-plantuml)

(let ((jar-path (glob-first-file "/usr/share/java/plantuml-*.jar"
                                 "/usr/share/plantuml/plantuml.jar")))
  (when (and (not (null jar-path))
             (f-exists? jar-path))
    (setq plantuml-jar-path jar-path)))


(provide 'ag-feat-plantuml)
