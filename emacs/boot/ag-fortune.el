(require 'f)
(require 'seq)
(require 'dash)

(defun fortune* ()
  (interactive)
  (let* ((dir "/usr/share/games/fortunes")
         (fortune-file (format "%s/%s" dir (seq-random-elt
                                            (->> (f-glob (format "%s/*.dat" dir))
                                                 (mapcar #'f-base))))))
    (fortune)))


(provide 'ag-fortune)
