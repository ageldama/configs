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

(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . web-mode))
