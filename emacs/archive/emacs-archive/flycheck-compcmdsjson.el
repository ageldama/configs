(require 'flycheck)
(require 'compcmdsjson-tiny)


(defvar-local flycheck-compcmdsjson/*last* nil)


(defun flycheck-compcmdsjson/run-and-capture-inc-dirs ()
  (-select (lambda (s) (not (equal "" s)))
           (split-string
            (shell-command-to-string
             "compile_commands_json_incdirs.py --print 2> /dev/null")
            "\n")))


(defun flycheck-compcmdsjson/forget ()
  (interactive)
  (message "Resetting: flycheck-compcmdsjson/*last*")
  (setq-local flycheck-compcmdsjson/*last* nil))

(defun flycheck-compcmdsjson/apply ()
  (interactive)
  ;; reset
  (when (not (null current-prefix-arg))
    (flycheck-compcmdsjson/forget))
  ;; body
  (when (and (null flycheck-compcmdsjson/*last*)
             (not (eq flycheck-compcmdsjson/*last* :not-found)))
    (message "Looking: compile_commands.json ...")
    ;;
    (let ((path (compcmdsjson-tiny/find-nearest)))
      (message "Found: %s" path)
      ;;
      (if (null path)
          (setq-local flycheck-compcmdsjson/*last* :not-found)
        ;; else:
        (progn
          ;; pushd, cd
          (let ((default-directory (f-parent path)))
            (message "cd: %s" default-directory)
            (cd default-directory)
            ;; run: "compile_commands_json_incdirs.py --print" ==> flycheck
            (let ((inc-dirs
                   (flycheck-compcmdsjson/run-and-capture-inc-dirs)))
              (message "inc-dirs: %s" inc-dirs)
              (setq flycheck-gcc-include-path inc-dirs)
              (setq flycheck-clang-include-path inc-dirs)
              (setq flycheck-cppcheck-include-path inc-dirs))
            ;; bye
            (setq-local flycheck-compcmdsjson/*last* path)
            (flycheck-buffer)
            )))
      ;; (message "pwd: %s" default-directory)
      )))


(provide 'flycheck-compcmdsjson)



