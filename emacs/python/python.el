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
"

(require 'company)
(require 'flycheck)
(require 'eldoc)
(require 'python)

;;; pip-requirements
(use-package pip-requirements :ensure t :pin melpa)

;;;
(use-package elpy :ensure t :pin melpa)

(use-package pyvenv :ensure t :pin melpa
    :init
    (pyvenv-mode +1)
    (pyvenv-tracking-mode +1))

;;; eldoc
(when nil
  (defun my-python-eldoc-mode ()
    (interactive)
    (setq-local elpy-documentation-function (lambda () (jedi:show-doc)))
    (eldoc-mode +1))

  (add-hook 'python-mode-hook 'my-python-eldoc-mode)
  )

;;; flycheck
;;; NOTE: install `flake8` and `pylint` to your virtualenv.
(flycheck-add-next-checker 'python-pycompile 'python-flake8)
(flycheck-add-next-checker 'python-flake8 'python-pylint)

(use-package company-jedi :ensure t :pin melpa
  :config (progn   (add-hook 'python-mode-hook 'jedi:setup)
		   (setq jedi:complete-on-dot t)
		   (add-hook 'python-mode-hook
			     (lambda () (add-to-list 'company-backends 'company-jedi)))
		   (add-hook 'python-mode-hook
			     (lambda () (flymake-mode -1)))
		   (elpy-enable)))

;; (use-package pylint :ensure t :pin melpa)

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


;; DONE: yapf?
;; DONE: eldoc? -- 그냥 쓰지마. 잘안됨. 모르겠답.
;; CANCEL: importmagic?
;; DONE: isort?
;; DONE: flake8?
;; DONE: flycheck?
;; DONE: pyvenv + dirlocals.el?
;; DONE: autopep8?

"
pytest
(nose :location local)

cython-mode

----

    semantic
    smartparens
    stickyfunc-enhance

    pyenv-mode
    pyvenv

(pylookup :location local)

    py-isort
    yapfify


----
xcscope
helm-cscope
helm-gtags
ggtags
"

