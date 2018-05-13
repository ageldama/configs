;;;; Code:
(load-file (expand-file-name "~/Projects/configs/emacs/dot-emacs-2018"))

;;; simplest layer support.
(defvar load-layer-base-path (expand-file-name "~/Projects/configs/emacs/"))

(defun load-layer (layer-name)
  "Specify LAYER-NAME as elisp filename to load."
  (interactive "fFile to load:")
  (let ((fn (if (file-exists-p layer-name)
		layer-name
	      (format "%s%s" load-layer-base-path layer-name))))
    (load-file fn)))

(defun load-cmake-ide-layer ()
  "Just load cmake-ide layer."
  (interactive)
  (load-layer "cmake-ide/cmake-ide.el"))



;;;EOF.
