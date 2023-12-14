(use-package helm :ensure t :pin melpa
  :diminish 'helm-mode
  :config (progn ;;(require 'helm-config)
	    (helm-mode +1)
	    (setq helm-split-window-in-side-p           t
		  helm-move-to-line-cycle-in-source     nil ; 맨 위/마지막에서 더 올라가면 특별한 항목들 선택이 불가해져서 꺼야함.
		  helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
		  helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
		  helm-ff-file-name-history-use-recentf t
		  helm-echo-input-in-header-line t
		  helm-mode-fuzzy-match t
		  helm-recentf-fuzzy-match t
		  helm-buffers-fuzzy-matching t
		  helm-recentf-fuzzy-match t
		  helm-buffers-fuzzy-matching t
		  helm-locate-fuzzy-match t
		  helm-M-x-fuzzy-match t
		  helm-semantic-fuzzy-match t
		  helm-imenu-fuzzy-match t
		  helm-apropos-fuzzy-match t
		  helm-lisp-completion-at-point nil)
	    (global-set-key (kbd "M-x") 'helm-M-x)
	    (global-set-key (kbd "M-s o") 'helm-occur)
	    (global-set-key (kbd "C-x C-f") 'helm-find-files)
	    (global-set-key (kbd "C-x b") 'helm-mini)
	    ))




;; "k" 'helm-show-kill-ring
;; "r" 'helm-register
;; "m" 'helm-mark-ring
;; "M" 'helm-all-mark-rings
;; "i" 'helm-imenu

;; "` r" 'helm-regexp
;; "` t" 'helm-top
;; "` p" 'helm-list-emacs-process
;; "` b" 'helm-bookmarks
