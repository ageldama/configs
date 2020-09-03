(use-package org :ensure t :pin org)


;;; org-roam
(use-package org-roam :ensure t :pin melpa
  :diminish
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "/home/jhyun/P/v3/org-roam.d/")
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n j" . org-roam-jump-to-index)
               ("C-c n b" . org-roam-switch-to-buffer)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))

(setq org-roam-capture-templates
      '(("d" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "${slug}"
         :head "#+SETUPFILE:./hugo_setup.org
#+HUGO_SECTION: zettels
#+HUGO_SLUG: ${slug}
#+TITLE: ${title}\n"
         :unnarrowed t)
        ("p" "private" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "private-${slug}"
         :head "#+TITLE: ${title}\n"
         :unnarrowed t)))

