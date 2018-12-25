(use-package dotnet :pin melpa :ensure t
  :config
  (when (boundp 'csharp-mode-hook)
    (add-hook 'csharp-mode-hook 'dotnet-mode))
  ;; and/or
  (when (boundp 'fsharp-mode-hook)
    (add-hook 'fsharp-mode-hook 'dotnet-mode)))

(use-package fsharp-mode :pin melpa :ensure t)

