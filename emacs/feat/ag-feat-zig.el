(use-package zig-mode :ensure t :pin melpa)



(defun zig/where-zig-bin ()
  (let ((cmd-out (string-trim
                  (shell-command-to-string "which zig"))))
    (if (string-prefix-p "/" cmd-out)
        (substring cmd-out
                   ;; excluding "/zig"$.
                   0 (- (length cmd-out) 4))
      ;; else: not-found
      nil)))


(defun zig/build-tags ()
  (interactive)
  (let ((zig-path (zig/where-zig-bin))
        (src-path (f-dirname (buffer-file-name))))
    (cl-flet ((squote-or-empty (s)
                               (if (s-blank? s)
                                   ""
                                 ;; else:
                                 (concat "'" s "'"))))
      ;; https://github.com/ageldama/configs/blob/master/ctags/zig.ctags
      (let* ((cmd-path-sq (squote-or-empty src-path))
             (zig-path-sq (squote-or-empty zig-path))
             (cmd (format "cd %s; ctags -e -R --languages=Zig %s %s"
                          cmd-path-sq
                          zig-path-sq
                          cmd-path-sq)))
        (let ((cmd-asked (read-shell-command "Shell: " cmd)))
          (compile cmd-asked))))))






(defhydra hydra-lang-zig ()
  "Zig"

  ("t" zig/build-tags "ctags" :exit t)

  ("SPC" nil))

(lang-mode-hydra-set 'zig-mode-hook 'hydra-lang-zig/body)





(provide 'ag-feat-zig)
