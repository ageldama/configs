;;; packages
(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if nil "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "org" (concat proto "://orgmode.org/elpa/")) t)
  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))
  (add-to-list 'package-archives (cons "elpa" (concat proto "://elpa.nongnu.org/nongnu/")))
  )

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;;
(provide 'ag-package)
