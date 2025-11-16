
(use-package counsel :ensure t :pin melpa
  :diminish
  :config (progn
            ;;
            (ivy-mode 1)
            (setq ivy-use-selectable-prompt     t  ;; <C-p>.
                  ivy-use-virtual-buffers       t
                  enable-recursive-minibuffers  t
                  ivy-re-builders-alist
                  '(
                    ;; (swiper      . ivy--regex-plus)
                    (counsel-M-x . ivy--regex-fuzzy)
                    ;; (t           . ivy--regex-fuzzy)
                    (t           . ivy--regex-plus)
                    ))
            ;; (ivy-configure 'counsel-M-x :initial-input "") ;; ^... 지우기귀찮.
            (global-set-key "\C-s" 'swiper)
            (global-set-key (kbd "M-s s") 'swiper-thing-at-point)
            (global-set-key (kbd "C-c C-r") 'ivy-resume)
            ;; (global-set-key (kbd "M-s M-z") 'counsel-fzf)
            (global-set-key (kbd "<f6>") 'ivy-resume)
            (global-set-key (kbd "M-x") 'counsel-M-x)
            (global-set-key (kbd "C-x C-f") 'counsel-find-file)
            (global-set-key (kbd "C-h a") 'counsel-apropos)
            ;; USE `helpful' INSTEAD:
            ;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
            ;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
            (global-set-key (kbd "<f1> l") 'counsel-find-library)
            (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
            (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
            (global-set-key (kbd "C-c g") 'counsel-git)
            (global-set-key (kbd "C-c j") 'counsel-git-grep)
            ;; (global-set-key (kbd "C-c k") 'counsel-rg)
            ;; (global-set-key (kbd "C-x l") 'counsel-locate)
            ;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
            (global-set-key (kbd "M-y") 'counsel-yank-pop)
            (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

  :bind
  ( :map global-map
    ("M-s M-b" . counsel-ibuffer)
    ("M-s M-g" . counsel-grep)
    ("M-s M-h" . counsel-command-history)
    ("M-s M-i" . counsel-imenu)
    ("M-s M-m" . counsel-mark-ring)
    ("M-s M-y" . counsel-yank-pop)
    ("M-s M-s" . counsel-outline)
    ("M-s M-z" . counsel-fzf)
    )
  )

(require 'ag-reinit)
(ag-reinit/add-as-interactive (diminish 'ivy-mode))


(provide 'ag-feat-counsel)
