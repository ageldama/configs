(use-package dwim-shell-command :ensure t :pin melpa
  :config
  (defun dwim-shell-command--completing-read ()
    (interactive)
    (let (commands)
      (mapatoms (lambda (s)
                  (when (and (commandp s)
                             (string-match-p "^dwim-shell-" (symbol-name s)))
                    (push s commands)))
                obarray)
      (sort commands #'string-lessp)
      (call-interactively
       (intern (completing-read "dwim-shell: " commands)))))
  )


(when (fboundp 'defhydra)
  (eval '(defhydra hydra-lang-dired ()
           "dired"

           ("d" dwim-shell-command--completing-read "dwim-shell-command" :exit t)

           ("SPC" nil)))

  (require 'ag-lang-mode)
  (lang-mode-hydra-set 'dired-mode-hook 'hydra-lang-dired/body))


(provide 'ag-feat-dwim-shell-command)
