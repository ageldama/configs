(require 'flycheck-compcmdsjson)
(require 'cc-mode)

(add-hook 'c-mode-common-hook #'flycheck-compcmdsjson/apply)

(define-key c-mode-base-map (kbd "C-c ! C-f") 'flycheck-compcmdsjson/apply)
(define-key c-mode-base-map (kbd "C-c ! C-M-f") 'flycheck-compcmdsjson/forget)


;; TODO compile_commands.json 하위디렉토리에서 검색?

;; TODO compile_commands.json / "file" 경로를 project-root으로
;; normalize <= from-build-dir

;; TODO compile_commands.json / incdir 경로이 rel-path이면
;; project-root, build-dir등에서 normalize.
