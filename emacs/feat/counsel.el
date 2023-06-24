(use-package counsel :ensure t :pin melpa
  :diminish
  :config (progn
            ;;
            (ivy-mode 1)
            (setq ivy-use-selectable-prompt     t  ;; <C-p>.
                  ivy-use-virtual-buffers       t
                  enable-recursive-minibuffers  t
                  ivy-re-builders-alist         '((swiper      . ivy--regex-plus)
                                                  (counsel-M-x . ivy--regex-fuzzy)
                                                  (t           . ivy--regex-plus)))
            (global-set-key "\C-s" 'swiper)
            (global-set-key (kbd "M-s s") 'swiper-thing-at-point)
            (global-set-key (kbd "C-c C-r") 'ivy-resume)
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
            (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

(diminish 'ivy-mode)

(use-package ivy-rich :ensure t :pin melpa
  :config (ivy-rich-mode +1))


(when (fboundp 'projectile-find-file)
  (use-package counsel-projectile
    :ensure t :pin melpa
    :config
    (setq counsel-projectile-rg-initial-input
          '(projectile-symbol-or-selection-at-point))))

;;;EOF.
