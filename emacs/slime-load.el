(add-to-list 'load-path "~/local/slime")

(require 'slime-autoloads)

(setq inferior-lisp-program "~/local/sbcl-1.2.3/run-sbcl.sh")

(setq common-lisp-hyperspec-root "/users/jonghyouk/local/HyperSpec/")

(setq slime-contribs '(slime-fancy))
