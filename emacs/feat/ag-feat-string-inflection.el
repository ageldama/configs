
(use-package string-inflection  :ensure t :pin melpa
  :config
  (when (fboundp 'defhydra)
    (eval '(defhydra hydra-string-inflection ()
             "
string-inflection:^^
----------------------------------------------------------
_c_: 'fooBar' lower-camelcase
_C_: 'FooBar' capital-camelcase
_p_: 'Foo_Bar' capital-underscore
_k_: 'foo-bar' kebab
_u_: 'foo_bar' underscore
_U_: 'FOO_BAR' upcase
"
             ("c" string-inflection-lower-camelcase :exit t)
             ("C" string-inflection-camelcase :exit t)
             ("p" string-inflection-capital-underscore :exit t)
             ("k" string-inflection-kebab-case :exit t)
             ("u" string-inflection-underscore :exit t)
             ("U" string-inflection-upcase :exit t)
             ("SPC" nil)))

    (require 'ag-hydra--main)
    (add-to-list 'hydra-mini/++extras
                 '("M-i" hydra-string-inflection/body "infl."))

    ))

(provide 'ag-feat-string-inflection)
