
(let ((jar-path (glob-first-file "/usr/share/java/ditaa-*.jar"
                               "/usr/share/ditaa/ditaa.jar")))
  (when (and (not (null jar-path))
             (boundp 'org-ditaa-jar-path)
             (not (f-exists? org-ditaa-jar-path)))
    (setq org-ditaa-jar-path jar-path)))


;;;
(provide 'ag-ditaa)
