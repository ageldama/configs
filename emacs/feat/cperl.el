
;; use cperl-mode instead of perl-mode
(setq auto-mode-alist (rassq-delete-all 'perl-mode auto-mode-alist))
(add-to-list 'auto-mode-alist
             '("\\.\\(p\\([lm]\\)\\)\\'" . cperl-mode))
(add-to-list 'auto-mode-alist
             '("\\.t$" . cperl-mode))
(add-to-list 'auto-mode-alist
             '("cpanfile$" . cperl-mode))

(setq interpreter-mode-alist (rassq-delete-all
                              'perl-mode interpreter-mode-alist))
(add-to-list 'interpreter-mode-alist
             '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist
             '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist
             '("miniperl" . cperl-mode))
