(add-to-list 'load-path "~/lisp/slime-2011-05-14/")
(add-to-list 'load-path "~/lisp/clojure-mode/")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-fancy))


(setq slime-use-autodoc-mode nil)

(eval-after-load "clojure-mode"
  '(progn
     (add-hook 'clojure-mode-hook
       (lambda ()
         (slime-autodoc-mode 0)))))
