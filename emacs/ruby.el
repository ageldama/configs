(add-hook 'ruby-mode-hook 
          (lambda ()
            (dolist (cmd '(
                           "cd %p; bundle exec rspec"
                           "cd %p; bundle exec"
                           "cd %p; rake -T -A"
                           "cd %d; ./%f"
                           "cd %d; rubocop -A"
                           ))
              (cl-pushnew cmd moonshot-runners :test #'string=))))

(use-package yaml-mode :ensure t :pin melpa)

(when (fboundp 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . web-mode)))
