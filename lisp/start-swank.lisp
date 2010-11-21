;;(load #p"/home/adaltan/lisp/asdf/asdf.lisp")
;;(push #P"/home/adaltan/lisp/slime-2010-11-05/" asdf:*central-registry*)

(asdf:load-system :swank)
(swank:create-server :port 4005
  :dont-close t :coding-system "utf-8-unix")