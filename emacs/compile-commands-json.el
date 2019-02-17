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
(require 'ht)

;;; Code:
(defun compile-commands-json/split-shellwords (s)
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


(defun compile-commands-json/cmd->include-dirs (s)
  "Extract include directories from shell command line string (`S`)."
  (->> (seq--into-list (compile-commands-json/split-shellwords s))
       (--filter (s-starts-with? "-I" it))
       (--map (s-chop-prefix "-I" it))))


(defun compile-commands-json/include-dirs (build-dir)
  "Read `compile_commands.json` in `BUILD-DIR`.
Parse it and collect every `-I...`-occurences as include
directory listing."
  (interactive "D")
  (let* ((fn (f-join build-dir "compile_commands.json"))
         (file-check? (unless (f-exists? fn)
                        (error "File not found: %s" fn)))
         (cmds (seq-map (lambda (i) (alist-get 'command i))
                        (json-read-file fn)))
         (result-ht (ht-create)))
    (seq-doseq (i cmds)
      (let ((inc-dirs (compile-commands-json/cmd->include-dirs i)))
        (seq-doseq (inc-dir inc-dirs)
          (ht-set! result-ht inc-dir 1))))
    (ht-keys result-ht)))


(provide 'compile-commands-json)
;;; compile-commands-json.el ends here
