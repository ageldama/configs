;;; compile-commands-json.el --- Parse `compile_commands.json` file

;; Copyright (C) 2019 Jong-Hyouk Yun

;; Authors: Jong-Hyouk Yun <ageldama@gmail.com>

;; URL: https://github.com/ageldama/compile-commands-json-el
;; Version: 0.0.1
;; Package-Requires: ((json "1.2") (seq "2.20") (s "1.12.0") (dash "2.15.0") (f "0.20.0") (ht "2.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;;
;;; Parse `compile_commands.json` and collect include directory
;;; listing.
;;;
;;; SYNOPSIS:
;;; (require 'compile-commands-json)
;;; (compile-commands-json/include-dir "/tmp/foo-build") ;; ==> '("/inc-dir1" "/inc-dir-another")

(require 'json)
(require 'seq)
(require 's)
(require 'dash)
(require 'cl)
(require 'f)
(use-package ht :ensure t)

;;; Code:
(defun make-read-compile-commands-in-dir (dir)
  (lexical-let ((dir-name dir))
    #'(lambda ()
        (let* ((fn (f-join dir-name "compile_commands.json"))
               (file-check? (unless (f-exists? fn)
                              (error "File not found: %s" fn))))
          (json-read-file fn)))))

(defun compile-commands-json-build-path-env ()
  (interactive)
  (getenv "BUILD_DIR"))

(defun read-compile-commands-build-path-env ()
  (let* ((dir (compile-commands-json-build-path-env))
         (dir-check?     (assert dir "Set `BUILD_DIR' env-var!"))
         (fn (f-join dir "compile_commands.json"))
         (file-check? (unless (f-exists? fn)
                              (error "File not found: %s" fn))))
    ;;(message "fn = %s" fn)
    (json-read-file fn)))

(defun read-compile-commands-rtags ()
  (with-temp-buffer
    (rtags-call-rc "--dump-compile-commands")
    (json-read-from-string (buffer-string))))

(defcustom read-compile-commands #'read-compile-commands-build-path-env
  "TODO")

(defun read-compile-commands-resolved-by-rtags ()
  (let* ((row  (compile-commands-json/matching-row
                                     #'read-compile-commands (buffer-file-name)))
         (dir (alist-get 'directory row))
         (fn (f-join dir "compile_commands.json"))
         (file-check? (unless (f-exists? fn)
                        (error "File not found: %s" fn))))
    (json-read-file fn)))

(defun compile-commands-json/split-shellwords-verbose (s)
  (let ((cmd "perl -MText::ParseWords -MJSON -e'@a=shellwords(<>); print(encode_json(\\@a));'")
        (out-buf nil)
        (ret-val nil))
    (with-temp-buffer
      (setq out-buf (current-buffer))
      (with-temp-buffer
        (insert s)
        (setq ret-val
              (shell-command-on-region (point-min) (point-max)
                                       cmd
                                       out-buf)))
      ;;
      (unless (zerop ret-val)
        (error "Exited with non-zero (%S) -- %S"
               ret-val cmd))
      (json-read-from-string (buffer-string)))))

(defun compile-commands-json/split-shellwords (s)
  (let* ((in-fn (make-temp-file "compile-commands-json"))
         (wrote (f-write s 'utf-8-unix in-fn))
         (out-fn (make-temp-file "splitted-compile-commands"))
         (cmd (format
               "cat %s | perl -MText::ParseWords -MJSON -e'@a=shellwords(<>); print(encode_json(\\@a));' > %s"
               in-fn out-fn))
         (result-json nil))
    (unless (f-exists? in-fn)
      (error "No file: %S" in-fn))
    (unwind-protect
        (progn
          (shell-command cmd)
          (setq result-json (json-read-file out-fn))
          result-json)
      (progn
        (f-delete in-fn)
        (f-delete out-fn)))))

(defun compile-commands-json/cmd->include-dirs (s)
  "Extract include directories from shell command line string (`S`)."
  (->> (seq--into-list (compile-commands-json/split-shellwords s))
       (--filter (s-starts-with? "-I" it))
       (--map (s-chop-prefix "-I" it))))


(defun compile-commands-json/include-dirs (read-compile-commands-fun)
  "Read `compile_commands.json` in `BUILD-DIR`.
Parse it and collect every `-I...`-occurences as include
directory listing."
  (interactive "D")
  (let* ((cmds (seq-map (lambda (i) (alist-get 'command i))
                        (funcall read-compile-commands-fun)))
         (result-ht (ht-create)))
    (seq-doseq (i cmds)
      (let ((inc-dirs (compile-commands-json/cmd->include-dirs i)))
        (seq-doseq (inc-dir inc-dirs)
          (ht-set! result-ht inc-dir 1))))
    (ht-keys result-ht)))

(defun compile-commands-json/%matching-row (read-compile-commands-fun file-name)
  (let* ((rows (funcall read-compile-commands-fun)))
    (seq-find (lambda (row) (equal (alist-get 'file row) file-name))
              rows)))

(defun compile-commands-json/matching-row (read-compile-commands-fun file-name)
  (let ((rows (compile-commands-json/%matching-row read-compile-commands-fun file-name)))
    (if (null rows)
        (seq-elt (funcall #'read-compile-commands) 0) ;; fallback
      rows)))

(defun compile-commands-json/compile-command (read-compile-commands-fun file-name)
  (interactive)
  (alist-get 'command (compile-commands-json/matching-row read-compile-commands-fun file-name)))

(defun compile-commands-json/rmsbolt-command (read-compile-commands-fun file-name)
  (let* ((cmd-parts (remove-if (lambda (s) (or (equal "-c" s)
                                               (equal file-name s)))
                               (compile-commands-json/split-shellwords
                                (compile-commands-json/compile-command read-compile-commands-fun file-name))))
         (pos (seq-position cmd-parts "-o")))
    (if (null pos)
        ;; then
        (s-join " " cmd-parts)
      ;; else
      (let* ((cmd-parts* (seq-partition cmd-parts pos))
             (cmd-parts** (seq-concatenate 'vector
                                           (first cmd-parts*)
                                           (seq-drop (second cmd-parts*) 2))))
        (s-join " " cmd-parts**)))))

(defun compile-commands-json/build-dir (read-compile-commands-fun file-name)
  (interactive)
  (alist-get 'directory (compile-commands-json/matching-row read-compile-commands-fun file-name)))



(provide 'compile-commands-json)
;;; compile-commands-json.el ends here
