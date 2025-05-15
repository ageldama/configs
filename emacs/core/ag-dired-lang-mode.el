
(defun objdump (filename)
  (interactive "f")
  (shell-command
   (concat "objdump -s -DrwC -L -g -F -GT -x --special-syms -z -S "
           filename)))

(defun dired-objdump ()
  (interactive)
  (let ((filename (dired-get-filename)))
    (objdump filename)))


(defhydra hydra-lang-dired ()
  "dired"

  ("D" dired-objdump "objdump" :exit t)

  ("SPC" nil))


(lang-mode-hydra-set 'dired-mode-hook 'hydra-lang-dired/body)


(provide 'ag-dired-lang-mode)
