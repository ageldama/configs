
;;; god-mode
(when nil
  (use-package god-mode :ensure t :pin melpa
    :config
    (progn
      ;; (define-key god-local-mode-map (kbd "z") #'hydra-mini/body)
      (define-key god-local-mode-map (kbd ".") #'repeat)

      (global-set-key (kbd "<escape>") #'god-local-mode)
      (define-key god-local-mode-map (kbd "i") #'god-local-mode)

      (global-set-key (kbd "C-x C-1") #'delete-other-windows)
      (global-set-key (kbd "C-x C-2") #'split-window-below)
      (global-set-key (kbd "C-x C-3") #'split-window-right)
      (global-set-key (kbd "C-x C-0") #'delete-window)

      (define-key god-local-mode-map (kbd "<f5>")
                  #'recompile-showing-compilation-window)

      (define-key god-local-mode-map (kbd "[") #'backward-paragraph)
      (define-key god-local-mode-map (kbd "]") #'forward-paragraph)

      ;; Big capitals:
      (define-key god-local-mode-map (kbd "W") #'ace-window)
      (define-key god-local-mode-map (kbd "B") #'ibuffer)
      (define-key god-local-mode-map (kbd "T") #'hydra/tab/body)

      ;; TODO HINT : C-, C-w, use the comma-key!

      ;; isearch
      (require 'god-mode-isearch)
      (define-key isearch-mode-map (kbd "<escape>") #'god-mode-isearch-activate)
      (define-key god-mode-isearch-map (kbd "<escape>") #'god-mode-isearch-disable)

      ;;
      (god-mode-all 1)
      )))
