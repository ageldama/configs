(require 'comint)
(require 'ansi-color)


(defun objdump (filename)
  (interactive "f")
  ;; extended-color 은 잘 동작안함.
  (let* ((cmd (concat
               "objdump -s -DrwC -L -g -F -GT -x --special-syms -z -S "
               "--visualize-jumps=color --disassembler-color=on "
               filename))
         (buf (generate-new-buffer (concat "*objdump* -- " cmd))))
    (with-current-buffer buf
      (ansi-color-for-comint-mode-on)
      (comint-mode)
      (display-buffer buf))
    (let ((proc (start-process-shell-command cmd buf cmd)))
      (set-process-filter proc 'comint-output-filter)
      (set-process-sentinel
       proc (lambda (proc evt)
              (message "objdump: %s" evt))))))

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
