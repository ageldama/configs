


(add-to-list 'load-path "~/lisp/clojure-mode")
(add-to-list 'load-path "~/lisp/slime-2010-11-05")
(add-to-list 'load-path "~/lisp/swank-clojure")



(require 'clojure-mode)

(require 'swank-clojure)





(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(setq slime-use-autodoc-mode nil)
(eval-after-load "clojure-mode"
  '(progn
     (add-hook 'clojure-mode-hook
       (lambda ()
         (slime-autodoc-mode 0)))))

(slime-setup '(slime-fancy))

;;; EOF