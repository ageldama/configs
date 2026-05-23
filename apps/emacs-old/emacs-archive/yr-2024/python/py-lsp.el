;;;; my python emacs layer.
;;;;
;;;; Jonghyouk Yun <ageldama@gmail.com>, 2018-05-14.
;;;;
"
# Either of these
pip install rope
pip install jedi

# flake8 for code checks
pip install flake8

# and autopep8 for automatic PEP8 formatting
pip install autopep8

# and yapf for code formatting
pip install yapf

python-language-server
"

;;; pip-requirements
(use-package pip-requirements :ensure t :pin melpa)

;;;
(use-package lsp-mode :ensure t :pin melpa)
(use-package lsp-python :ensure t :pin melpa)
(add-hook 'python-mode-hook #'lsp-python-enable)


;;; isort
(use-package py-isort :ensure t :pin melpa)

;;;
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
	    ))


;;; Python + Org
(require 'ob-python)


;;; General keymap.
;; (when (fboundp 'general-create-definer)
;;   (my-local-leader-def :keymaps 'python-mode-map
;;    ;; navs, docs
;;    "." 'jedi:goto-definition
;;    "," 'jedi:goto-definition-pop-marker
;;    "/" 'helm-jedi-related-names
;;    "?" 'jedi:show-doc
;;    "D" 'elpy-doc
;;    "S" 'elpy-rgrep-symbol
;;    ;; yapf, isort, autopep8
;;    "i" 'py-isort-buffer
;;    "y" 'elpy-yapf-fix-code
;;    "f" 'elpy-autopep8-fix-code
;;    ;; venv
;;    "v" '(:ignore t :which-key "pyvenv")
;;    "v c" 'pyvenv-create
;;    "v a" 'pyvenv-activate
;;    "v w" 'pyvenv-workon
;;    "v d" 'pyvenv-deactivate
;;    ;; test
;;    "t" 'elpy-test
;;    ))


(defconst agelmacs/layer/python t)
