(require 'profiler)

(progn
  (profiler-stop)
  (profiler-start 'cpu+mem)
  (load-file "~/.emacs")
  (profiler-report)
  (profiler-stop))
