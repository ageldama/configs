
(defhydra hydra/tab (:exit nil)
  "tabs"
  ("<left>"   #'tab-previous
   "prev" )
  ("<right>"  #'tab-next
   "next" )
  ("<tab>"    #'tab-recent
   "recent" )
  ("<down>"   #'tab-new
   "new" )
  ("<up>"     #'tab-list
   "list" )
  ("X"        #'tab-close
   "close" )
  ("SPC" nil))


;;;
(provide 'ag-hydra--tab)
