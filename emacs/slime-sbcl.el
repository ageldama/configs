(add-to-list 'load-path "~/lisp/slime-2011-08-12/")
(setq inferior-lisp-program "~/lisp/sbcl-1.0.50-x86-linux/run-sbcl.sh")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(setq common-lisp-hyperspec-root "/usr/share/doc/hyperspec/")
(slime-setup '(slime-fancy))
;(slime-setup)
(slime)
