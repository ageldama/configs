;;; -*- mode: emacs-lisp; coding: utf-8; -*-

;;; setup self

(require 'f)

(message (format "emacs config file: %s" load-file-name))

(setq-local %myself-dir (f-dirname load-file-name))

(defun %add-load-path-under-myself (rel-path)
  (cl-pushnew (f-join %myself-dir rel-path) load-path
              :test #'equal))

(%add-load-path-under-myself "elisp")

;;; basics

(require 'ag-el)
(require 'ag-emacs-sensible)
(require 'ag-package)















(use-package f :ensure t :pin melpa)

(use-package s :ensure t :pin melpa)


(use-package org :ensure t :pin org
  :config
  (require 'org-crypt)
  (org-crypt-use-before-save-magic)
  (setq org-tags-exclude-from-inheritance '("crypt")
        org-crypt-key "ageldama@gmail.com")

  ;; (setq org-confirm-babel-evaluate nil)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (shell . t)
     (awk . t)
     (perl . t)
     (python . t)
     (dot . t)
     (plantuml . t)
     (ditaa . t)
     (org . t)
     (sqlite . t)
     (C . t)
     ))
  )


(defmacro file-find-one (&rest file-globs)
  `(seq-first (append
           ,@(mapcar (lambda (file-glob)
                       `(file-expand-wildcards ,file-glob))
                     file-globs))))

 
(let ((jar-path (file-find-one "/usr/share/java/plantuml-*.jar"
                               "/usr/share/plantuml/plantuml.jar")))
  (when (and (not (null jar-path))
             (boundp 'org-plantuml-jar-path)
             (or (null org-plantuml-jar-path)
                 (string-empty-p org-plantuml-jar-path))
             (f-exists? jar-path))
    (setq org-plantuml-jar-path jar-path)))


(let ((jar-path (file-find-one "/usr/share/java/ditaa-*.jar"
                               "/usr/share/ditaa/ditaa.jar")))
  (when (and (not (null jar-path))
             (boundp 'org-ditaa-jar-path)
             (not (f-exists? org-ditaa-jar-path)))
    (setq org-ditaa-jar-path jar-path)))


(use-package modus-themes :ensure t :pin melpa)

;; (when (display-graphic-p)
;;   (load-theme 'modus-vivendi-tinted t ))



(use-package hydra :ensure t :pin melpa)



(use-package which-key :ensure t
  :diminish which-key-mode
  :config (progn (which-key-mode)
                 (which-key-setup-side-window-bottom)
                 (setq which-key-max-description-length 200)))



(use-package writeroom-mode :ensure t :pin melpa)


;; (use-package telephone-line :ensure t :pin melpa)
;; (telephone-line-mode 1)

(use-package smart-mode-line :ensure t :pin melpa
  :config
  (setq sml/no-confirm-load-theme t
        sml/theme
        ;; 'dark
        ;; 'light
        'respectful
        )
  (when window-system
    (sml/setup))
  )


;;;
(use-package avy :ensure t :pin melpa
  :custom
  (avy-timeout-seconds 0.3)
  (avy-style 'pre)

  :config
  (progn
    ;; (global-set-key (kbd "C-'") 'avy-goto-char-timer)
    ;; (global-set-key (kbd "C-\"") 'avy-goto-word-1)
    ;; (global-set-key (kbd "C-:") 'avy-goto-line)
    (global-set-key (kbd "M-g SPC") 'avy-goto-char-timer)
    ;; (global-set-key (kbd "M-g M-g") 'goto-line)
    (global-set-key (kbd "M-g l") 'avy-goto-line)
    (global-set-key (kbd "M-g f") 'avy-goto-char)
    (global-set-key (kbd "M-g w") 'avy-goto-word-1)
    (global-set-key (kbd "M-g W") 'avy-goto-word-0)
    ;; (global-set-key (kbd "M-g j") 'hydra-avy-goto/body)
    (global-set-key (kbd "M-g M-g") 'avy-resume)
    (global-set-key (kbd "M-g ,") 'avy-pop-mark)
    ))



;;; Dired
(setq dired-dwim-target t
      wdired-confirm-overwrite t
      wdired-use-interactive-rename t
      )


;;; Org
(add-hook 'org-mode-hook
          (lambda ()
            (when (fboundp 'flycheck-mode)
              (flycheck-mode -1))
            ;;
            (setq truncate-lines nil
                  org-adapt-indentation t
                  )
            (auto-fill-mode +1)
            ))


(add-hook 'fundamental-mode-hook
          (lambda ()
            (auto-fill-mode +1)))



(setq org-log-done 'time)
(setq org-startup-with-inline-images t)


;;;
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))




(use-package ace-window :ensure t :pin melpa
  :config (global-set-key (kbd "C-x o") 'ace-window))



;;; diary, memo
(require 'f)  ;; elpa-f
(require 's)  ;; elpa-s
(require 'org)  ;; elpa-org
(require 'cl)

(load-file (s-concat minimi-config-path "/cal-dt.el"))

;; (diary/new-or-open-memo)
;; (diary/new-or-open-org-file)


(defvar *v3/plan-path* "~/P/v3/PLAN.org")

(defun v3/open-plan ()
  (interactive)
  (find-file *v3/plan-path*))



;;; Don't forget `M-x esup', profile your `.emacs'.
;; (setq gc-cons-threshold
;;       (if (< (or (car (memory-info)) 9999999999999999)
;;              (* 1024 1024 8))
;;           (* 1024 1024 500) ; 500 MiB
;;         ;; or, 100 MiB
;;         (* 1024 1024)))

(defvar *my-gc-timer* nil)

(defun my-gc-start-timer ()
  (interactive)
  (when (null *my-gc-timer*)
    (setq *my-gc-timer*
          (run-with-idle-timer 60 t
                               (lambda ()
                                 (garbage-collect))))))

(defun my-gc-cancel-timer ()
  (interactive)
  (when *my-gc-timer*
    (cancel-timer *my-gc-timer*)
    (setq *my-gc-timer* nil)))

(defun my-gc-toggle-timer ()
  (interactive)
  (if *my-gc-timer*
      (progn (my-gc-cancel-timer)
             (message "GC timer: cancelled"))
    (progn (my-gc-start-timer)
           (message "GC timer: started -- %s" *my-gc-timer*))))

;;(my-gc-start-timer)


;;; battery

(defun toggle-battery-saving-mode ()
  (interactive)
  (when (fboundp #'global-flycheck-mode)
    (call-interactively #'global-flycheck-mode -1))
  (when (fboundp #'global-eldoc-mode)
    (call-interactively #'global-eldoc-mode    -1))
  (when (fboundp #'global-company-mode)
    (call-interactively #'global-company-mode  -1))
  ;;(global-hl-todo-mode)
  )


(defun buffer-path-and-line-col ()
  (interactive)
  (let ((pos (format "%s\t%s\t%s" (or (buffer-file-name) default-directory)
                     (line-number-at-pos) (current-column))))
    (kill-new pos)
    (message "Path (Yanked): %s" pos)))


;;;
;; (use-package eshell-toggle :ensure t :pin melpa)

;;;

(defun def-hydras ()

  (defhydra hydra-files (:exit t)
    ("n" find-name-dired "dired-by-name")

    ("M-s f" (lambda () (interactive)
               (find-file (s-concat "/sudo:root@localhost:" (or (buffer-file-name) "/"))))
     "sudo:file")

    ("M-s d" (lambda () (interactive)
               (find-file (s-concat "/sudo:root@localhost:"
                                    (file-name-directory (or (buffer-file-name) "/")))))
     "sudo:dired")

    ("M-l f" find-file-literally "file-lit")
    ("M-l c" (lambda () (interactive)
               (find-file-literally (buffer-file-name)))
     "cur-lit")

    ("z" counsel-fzf "fzf")

    ("M-w" buffer-path-and-line-col "copy-path-linum"))


  (defhydra hydra-local-vars (:exit t)
    ("d"  add-dir-local-variable  "dir-local")
    ("f"  add-file-local-variable "file-local")
    ("p"  add-file-local-variable-prop-line "prop-line"))


  (eval
   `(defhydra hydra-misc-toggles (:exit t)
      "toggles"
      ("l" display-line-numbers-mode "linum")
      ("s" global-whitespace-mode "whitespaces")
      ("M-s" server-start "emacs-server")
      ("z" zone "zone")
      ("G" my-gc-toggle-timer "gc-timer")
      ("b" toggle-battery-saving-mode "battery-saving")
      ,@(when (fboundp 'writeroom-mode)
          '(("w" writeroom-mode "writeroom")))
      (":" toggle-evil-mode "evil")))


  (defhydra hydra-org (:exit t)
    ("a" org-agenda "org-agenda")
    ("d" diary/new-or-open-org-file "diary" )
    ("m" diary/new-or-open-memo "memo" )
    ("p" v3/open-plan "plan" ))


  (defhydra hydra-git (:exit t)
    ("w" mini-git/gwip "gwip" )
    ("a" mini-git/add "add" )
    ("s" mini-git/status "status" )
    ("p" mini-git/push "push" )
    ("F" mini-git/pull "pull" )
    ("R" mini-git/remote-v "remote-v" )
    )
  

  (eval
   `(defhydra hydra-mini (:exit t) ;;(global-map "<f12>" :exit t)
      "minimi"

      ("<SPC>" avy-goto-char-timer "avy")
      (";" avy-resume "avy-resume")
      
      ("`" menu-bar-open "menu-bar" )

      ,@(when (fboundp 'embark-act)
          '(("<tab>" embark-act "embark" )))

      ,@(when (fboundp 'helm-do-grep-ag)
          '(("\\" helm-do-grep-ag "helm-do-grep-ag" )))

      ("." xref-find-definitions "xref-def")

      ;; ,@(when (fboundp 'helm-resume)
      ;;     '(("," helm-resume "helm-resume" )))

      ;; ,@(when (fboundp 'helm-bookmarks)
      ;;     '(("B" helm-bookmarks "bookmks" )))

      ;; ,@(when (fboundp 'counsel-bookmark)
      ;;     '(("B" counsel-bookmark "bookmks" )))

      ;; ,@(when (fboundp 'helm-imenu)
      ;;     '(("I" helm-imenu "imenu" )))

      ,@(when (fboundp 'counsel-imenu)
          '(("C-i" counsel-imenu "imenu" )))

      ,@(when (fboundp 'helm-all-mark-rings)
          '(("R" helm-all-mark-rings "markring" )))

      ,@(when (fboundp 'counsel-mark-ring)
          '(("R" counsel-mark-ring "markring" )))

      ("b" (lambda () (interactive)
             (if (fboundp 'helm-buffers-list)
                 (helm-buffers-list)
               ;; else
               (ibuffer)))
       "buf")

      ("o" hydra-org/body "org")

      ("f" hydra-files/body "files" )

      ("u" undo-tree-visualize "undo-tree" )
      
      ,@(when (fboundp 'magit-status)
          '(("g" magit-status "magit" )))

      ("G" hydra-git/body "git")

      ("$" eshell "eshell")

      ("t" tab/hydra/body "tabs")
      
      ("C-$" (lambda () (interactive) (ansi-term shell-file-name)) "term")

      ,@(when (fboundp 'browse-kill-ring)
          '(("M-k" browse-kill-ring "kill-ring" )))

      ,@(when (fboundp 'helm-show-kill-ring)
          '(("k" helm-show-kill-ring "kill-ring" )))

      ,@(when (fboundp 'counsel-yank-pop)
          '(("k" counsel-yank-pop "yank-pop" )))
      
      ("C-k" kill-current-buffer "kill-cur-buf" )

      ,@(when (fboundp 'counsel-recentf)
          '(("r" counsel-recentf "recentf" )))

      ("-" hydra-misc-fns/body "misc-fns" )

      ("'" hydra-misc-toggles/body "toggles" )

      ,@(when (fboundp 'hydra-moonshot/body)
          '(("x" hydra-moonshot/body "moonshot" )))

      ,@(when (fboundp 'hydra-string-inflection/body)
          '(("M-i" hydra-string-inflection/body
             "infl.")))

      ,@(when (fboundp 'hydra-multiple-cursors/body)
          '(("M-c" hydra-multiple-cursors/body "mcurs" )))

      ,@(when (fboundp 'hydra-yas/body)
          '(("&" hydra-yas/body "yas" )))

      ,@(when (fboundp 'hydra-flycheck/body)
          '(("M-c" hydra-flycheck/body "flychk" )))

      ("M-v" hydra-local-vars/body "local-vars" )

      ,@(when (and (fboundp 'projectile-mode) (fboundp 'helm-projectile))
          '(("p" helm-projectile "projectile" )))

      ,@(when (and (fboundp 'projectile-mode) (fboundp 'counsel-projectile))
          '(("p" counsel-projectile "prj" )))

      ("P" projectile-commander "prj-cmdr" )

      ("w" avy-goto-word-1 "goto-word")
      ("l" avy-goto-line "goto-line")

      ("C-r" recompile-showing-compilation-window "recompile")

      ,@(when (fboundp 'eglot)
          '(("e" hydra-eglot/body "eglot"))

          )))

  (defhydra hydra-misc-fns ()
    "
Misc:^^
--------------------------
_p_ : list-proc
_b_ : bookmarks
_d_ : search sdcv
_s_ : del-trail-ws
_G_ : gc

_SPC_ : cancel
"
    ("p"  counsel-list-processes :exit t)
    ("b"  counsel-bookmark :exit t)
    ("d"  sdcv-search-input :exit t)
    ("s"  delete-trailing-whitespace :exit t)
    ("G"  garbage-collect :exit t)

    ("SPC" nil))

  ) ;; def-hydras




(defun gen-input(KEYS)
  (setq  unread-command-events (nconc (listify-key-sequence (kbd KEYS)) unread-command-events)))

(defun my-simulate-key-event (event &optional N)
  "Simulate an arbitrary keypress event.

This function sets the `unread-command-events' variable in order to simulate a
series of key events given by EVENT. Can also For negative N, simulate the
specified key EVENT directly.  For positive N, removes the last N elements from
the list of key events in `this-command-keys' and then appends EVENT.  For N nil,
treat as N=1."
  (let ((prefix (listify-key-sequence (this-command-keys)))
        (key (listify-key-sequence event))
        (n (prefix-numeric-value N)))
    (if (< n 0)
        (setq prefix key)
      (nbutlast prefix n)
      (nconc prefix key))
    (setq unread-command-events prefix)))


(def-hydras)







(defhydra hydra/tab (:exit nil)
  "tabs"
  ("<left>"   #'tab-previous
   "prev" )
  ("<right>"  #'tab-next
   "next" )
  ("<tab>"    #'tab-recent
   "recent" )
  ("<down>"   #'tab-new
   "new" )
  ("<up>"     #'tab-list
   "list" )
  ("X"        #'tab-close
   "close" )
  ("SPC" nil))





;;;

(define-key prog-mode-map (kbd "M-n") 'next-error)
(define-key prog-mode-map (kbd "M-p") 'previous-error)




;;; wgrep: writable grep
(use-package wgrep :ensure t :pin melpa)




;;; ibuffer
(if (fboundp 'helm-buffers-list)
    (progn (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
           (global-set-key (kbd "C-x B") 'ibuffer))
  (global-set-key (kbd "C-x C-b") 'ibuffer))




;;; expand-region
(use-package expand-region :ensure t :pin melpa
  :config 
  (global-set-key (kbd "C-=") 'er/expand-region))



;;; https://cute-jumper.github.io/emacs/2016/02/22/my-simple-setup-to-avoid-rsi-in-emacs

(defhydra hydra-expand-region
  (:body-pre (call-interactively 'set-mark-command)
             :exit nil)
  "hydra for mark commands"
  ("=" er/expand-region "expand")
  ("P" er/mark-inside-pairs "in-pair")
  ("Q" er/mark-inside-quotes "in-quote")
  ("p" er/mark-outside-pairs "out-pair")
  ("q" er/mark-outside-quotes "out-quote")
  ("d" er/mark-defun "defun")
  ("c" er/mark-comment "comment")
  ("." er/mark-text-sentence "sentence")
  ("h" er/mark-text-paragraph "paragraph")
  ("w" er/mark-word "word")
  ("u" er/mark-url "url")
  ("m" er/mark-email "email")
  ("s" er/mark-symbol "symbol")
  ("j" (funcall 'set-mark-command t) :exit nil)
  ("SPC" nil))


(global-set-key (kbd "C-+") 'hydra-expand-region/body)


;;;
(defmacro def-compile-no-arg-cmd (name &rest body)
  (let ((cmd (gensym "cmd-"))
        (arg (gensym "arg-")))
    `(defun ,name (,arg)
       (interactive "P")
       (let ((,cmd ,@body))
         (unless (null ,arg)
           (setf ,cmd 
                 (read-string "[git-cmd]: " ,cmd)))
         (compile ,cmd)))))




;;; git / wip
(require 'subr-x)

(defun git/find-nearest-repo ()
  (interactive)
  (f-traverse-upwards
   (lambda (p)
     (message "... %s" p)
     (let ((git-dir (format "%s/.git"
                            (string-remove-suffix "/" p))))
       (and (f-dir? p)
            (f-dir? git-dir))))
   default-directory))




(def-compile-no-arg-cmd mini-git/gwip
                        (let ((commit-msg "--wip-- [skip ci]")
                              (git-root (git/find-nearest-repo)))
                          (if (null git-root)
                              (error "Not a/in git-repos? [%s]"
                                     default-directory)
                            ;; else: found `.git/`:
                            (format "cd '%s' && git commit -am '%s'"
                                    git-root commit-msg))))


(def-compile-no-arg-cmd mini-git/add 
                        (format "cd '%s' && git add '%s'"
                                default-directory
                                (f-relative (buffer-file-name)
                                            default-directory)))


(def-compile-no-arg-cmd mini-git/status 
                        (format "cd '%s' && git status" default-directory))


(def-compile-no-arg-cmd mini-git/push
                        (format "cd '%s' && git push" default-directory))


(def-compile-no-arg-cmd mini-git/pull
                        (format "cd '%s' && git pull" default-directory))


(def-compile-no-arg-cmd mini-git/remote-v
                        (format "cd '%s' && git remote -v" default-directory))



;;; compile & recompile

(if (and (>= emacs-major-version 28)
         (fboundp 'ansi-color-compilation-filter))
    ;; then
    (unless (member 'ansi-color-compilation-filter compilation-filter-hook)
      (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))
  ;; else
  (progn
    (defun colorize-compilation-buffer ()
      (let ((inhibit-read-only t))
        (ansi-color-apply-on-region compilation-filter-start (point))))
    (unless (member 'colorize-compilation-buffer compilation-filter-hook)
      (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))))

(defun recompile-showing-compilation-window ()
  (interactive)
  (let* ((frm+wnd-lst
          (apply #'append
                 (mapcar (lambda (frm)
                           (with-selected-frame frm
                             (mapcar (lambda (wnd) (cons frm wnd))
                                     (window-list))))
                         (visible-frame-list))))
         (comp-frm-wnd (seq-find #'(lambda (frm-wnd)
                                     (with-selected-frame (car frm-wnd)
                                       (with-current-buffer (window-buffer (cdr frm-wnd))
                                         (or (member major-mode '(compilation-mode grep-mode go-test-mode))
                                             )
                                         )))
                                 frm+wnd-lst)))
    (if comp-frm-wnd
        (progn (with-selected-frame (car comp-frm-wnd)
                 (with-current-buffer (window-buffer (cdr comp-frm-wnd)) (recompile))))
      ;; else
      (progn (message "no comile-buffer found")
             (call-interactively 'compile)))))


(global-set-key (kbd "<f5>")
                #'recompile-showing-compilation-window)

;; C-u <f5> : ...을 compilation buffer에서 직접 실행하길 원해서.
;; (`<esc> g r` 안될 때에)
(define-key compilation-mode-map (kbd "<f5>") #'recompile)
(define-key compilation-minor-mode-map (kbd "<f5>") #'recompile)





;;; undo-tree
(use-package undo-tree
  :diminish 
  :ensure t
  :init (global-undo-tree-mode)
  :config (setq undo-tree-auto-save-history nil))



;;; Evil:

(let ((evil-want-keybinding nil))
  (use-package evil :ensure t :pin melpa))

(setq evil-want-integration t
      evil-want-keybinding t)
(evil-set-undo-system 'undo-tree)

(evil-mode +1)

(setq evil-default-state 'normal) ;;emacs)



(defun toggle-evil-mode ()
  (interactive)
  (evil-mode (if (null evil-state) 1 -1)))



(global-set-key (kbd "<f7>") 'toggle-evil-mode)



(defun my-evil-jump-other-win ()
  (interactive)
  (split-window)
  (evil-jump-to-tag))

(evil-global-set-key 'normal (kbd "g D") 'my-evil-jump-other-win)





;;;

(defvar-local lang-mode-hydra nil)


(defmacro lang-mode-hydra-set (mode-hook hydra-body)
  `(add-hook ,mode-hook
             (lambda () (setq-local lang-mode-hydra
                                    (symbol-function ,hydra-body)))))



(defun do-lang-mode-hydra ()
  (interactive)
  (if lang-mode-hydra
      (call-interactively lang-mode-hydra)
    ;; else
    (message "Null lang-mode-hydra local-var")))


(evil-global-set-key 'normal (kbd "SPC") 'hydra-mini/body)

(evil-global-set-key 'normal (kbd "\\") 'do-lang-mode-hydra)

(global-set-key (kbd "C-c 8") 'hydra-mini/body)
(global-set-key (kbd "C-c 9") 'do-lang-mode-hydra)

(global-set-key (kbd "<f8>") 'hydra-mini/body)
(global-set-key (kbd "<f9>") 'do-lang-mode-hydra)



;;;
(use-package diminish :ensure t :pin melpa
  :config
  (progn
    (diminish 'visual-line-mode)
    (diminish 'which-key-mode)
    ))



;;; evil-collection : final retouches
;;;
;; Warning (evil-collection): Make sure to set `evil-want-keybinding' to nil before loading evil or evil-collection.
;; See https://github.com/emacs-evil/evil-collection/issues/60 for more details.
(let ((evil-want-keybinding nil))
  (use-package evil-collection
    :after evil
    :ensure t :pin melpa
    :config
    (progn (evil-collection-init)
           (diminish 'evil-collection-unimpaired-mode ""))
    ))




(provide 'e-2025)

;;; EOF.
