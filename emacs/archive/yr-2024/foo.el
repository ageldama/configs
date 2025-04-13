
(message (format "load-file-name: %s" (f-dirname load-file-name)))


(f-join "/etc" "passwd")

(provide 'foo)



;;; ----


(push "~/w" load-path)

(cl-pushnew "~/P/configs/emacs" load-path :test #'equal)

(unload-feature 'foo)

(require 'foo)

(require 'e-2025)
