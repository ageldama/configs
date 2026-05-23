
;;; moonshot

(quelpa '(moonshot :repo "ageldama/moonshot" :fetcher github))
;;(use-package moonshot :ensure t :pin melpa)

(require 'moonshot)

(defhydra hydra-moonshot ()
  "
Moonshot^^
---------------------------------
_x_ run-exe 
_d_ debug 
_c_ run-cmd

_SPC_ cancel
"
  ("x" moonshot-run-executable :exit t)
  ("d" moonshot-run-debugger :exit t)
  ("c" moonshot-run-runner :exit t)
  ("SPC" nil)
  )
