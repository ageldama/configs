
(require 'subr-x)
(require 'f)
(require 'ag-el)


(defun git/find-nearest-repo ()
  (interactive)
  (f-traverse-upwards
   (lambda (p)
     (message "... %s" p)
     (let ((git-dir (format "%s/.git"
                            (string-remove-suffix "/" p))))
       (and (f-dir? p)
            (f-dir? git-dir))))
   default-directory))




(def-compile-no-arg-cmd mini-git/gwip
                        (let ((commit-msg "--wip-- [skip ci]")
                              (git-root (git/find-nearest-repo)))
                          (if (null git-root)
                              (error "Not a/in git-repos? [%s]"
                                     default-directory)
                            ;; else: found `.git/`:
                            (format "cd '%s' && git commit -am '%s'"
                                    git-root commit-msg))))


(def-compile-no-arg-cmd mini-git/add
                        (format "cd '%s' && git add '%s'"
                                default-directory
                                (f-relative (buffer-file-name)
                                            default-directory)))


(def-compile-no-arg-cmd mini-git/status
                        (format "cd '%s' && git status" default-directory))


(def-compile-no-arg-cmd mini-git/push
                        (format "cd '%s' && git push" default-directory))


(def-compile-no-arg-cmd mini-git/pull
                        (format "cd '%s' && git pull" default-directory))


(def-compile-no-arg-cmd mini-git/remote-v
                        (format "cd '%s' && git remote -v" default-directory))



;;;
(provide 'ag-mini-git)
