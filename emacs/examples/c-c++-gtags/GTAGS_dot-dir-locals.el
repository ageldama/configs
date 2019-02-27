((nil . (
				 (eval . (let ((root (projectile-project-root)))
									 (message "PROJECT-BUILD-PATH: %S" root)
									 (let ((build-dir (concat root "../build-cpp_scratchpad/")))
										 (setq-local project-build-path build-dir)
										 (setq-local flycheck-clang-tidy-build-path build-dir))))
				 )))
