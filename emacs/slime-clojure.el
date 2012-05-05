;;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; NOTE: slime 로딩 자동으로 하니까, 다른 slime은 로딩 안되도록 주의!!!
;;;
;;; ... lein 1.x일때는 다음처럼 플러그인을 설치
;;; > lein plugin install swank-clojure 1.4.2
;;; 아니면 아예 의존성으로 걸어주기(leiningen 2.x+)
;;;
;;; 그리고 M-x clojure-jack-in
;;;


(add-to-list 'load-path "~/local/clojure-mode/")
(require 'clojure-mode)

;(slime-setup '(slime-fancy))
