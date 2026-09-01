(require 'ag-el)
(require 'f)
(require 'ob-plantuml)

(use-package plantuml-mode :ensure t :pin melpa
  :config

  (let ((jar-path (glob-first-file "/usr/local/share/java/plantuml/plantuml.jar"
                                   "/usr/share/java/plantuml-*.jar"
                                   "/usr/share/plantuml/plantuml.jar")))
    (when (and (not (null jar-path))
               (boundp 'org-plantuml-jar-path)
               (or (null org-plantuml-jar-path)
                   (string-empty-p org-plantuml-jar-path))
               (f-exists? jar-path))
      (setq org-plantuml-jar-path jar-path))))


;;;
(provide 'ag-feat-ob-plantuml)
