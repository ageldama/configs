;;; evil-surround
(use-package evil-surround
  :ensure t :pin melpa
  :config
  (global-evil-surround-mode 1))
"
    'Hello world!'

        --> cs'<q> :

    <q>Hello world!</q>



    ysiw] (iw is a text object):

        [Hello] world!



    wrap the entire line in parentheses with yssb or yss):

        ({ Hello } world!)



    Revert to the original text: ds{ds)

        Hello world!

"
