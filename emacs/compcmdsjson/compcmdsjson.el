(provide 'compcmdsjson)


(defvar *compcmdsjson--incdirs* nil)


(defun compcmdsjson-clear-incdirs-cache ()
  (setq-local *compcmdsjson--incdirs* nil))


(defun compcmdsjson-get-incdirs (json-fn src-fn)
  (if (null *compcmdsjson--incdirs*)
      ;; then
      (let ((inc-dirs (split-string
                       (shell-command-to-string 
                        (format "incdirs.py \"%s\" \"%s\""
                                json-fn src-fn)))))
        (setq-local *compcmdsjson--incdirs* inc-dirs)
        inc-dirs)
    ;; else
    *compcmdsjson--incdirs*))


(defun compcmdsjson-get-compcmds (json-fn src-fn)
  (string-trim-right
   (shell-command-to-string 
    (format "compcmd.py \"%s\" \"%s\"" json-fn src-fn))))


(defun compcmdsjson-get-compcmds-rmsbolt (json-fn src-fn)
  (let* ((cmd (string-trim-right
               (shell-command-to-string 
                (format "compcmd.py \"%s\" \"%s\" --no-c-and-o"
                        json-fn src-fn))))
         (cmds (split-string cmd "\n")))
    (if (> (length cmds) 1)
        ;; then
        (completing-read "Select one> " cmds)
      ;; else
      cmd)))
    


