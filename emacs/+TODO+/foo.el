
(message (format "load-file-name: %s" (f-dirname load-file-name)))


(f-join "/etc" "passwd")

(provide 'foo)



;;; ----


(push "~/w" load-path)

(push "~/P/configs/emacs" load-path)

(unload-feature 'foo)

(require 'foo)

(require 'e-2025)
