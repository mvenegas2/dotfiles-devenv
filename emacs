(add-to-list 'load-path "~/.emacs.d/lisp/")
(setq-default fill-column 80)
(setq-default c-basic-offset 2)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(global-set-key "\C-u" '(lambda () (interactive) (kill-line 0)) ) ;C-u kills to the left

(add-to-list
 'auto-mode-alist
 '("\\.kps$" . python-mode))

(add-to-list
 'auto-mode-alist
 '("\\.tex$" . latex-mode))

(add-to-list
 'auto-mode-alist
 '("Jenkinsfile" . groovy-mode))

(add-hook 'latex-mode-hook 'turn-on-auto-fill)
(add-hook 'latex-mode-hook 'flyspell-mode)

(setq ediff-split-window-function 'split-window-sensibly)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

(setq flymake-gui-warnings-enabled nil)

;; (add-hook 'find-file-hook 'flymake-find-file-hook)
(add-hook 'python-mode-hook 'flymake-mode)

(add-hook 'python-mode-hook 'blacken-mode)
(add-hook 'python-mode-hook 'isortify-mode)

;; hclfmt
(defun hclfmt-buffer ()
  (interactive)
  (let ((line (line-number-at-pos)))
    ;; replace buffer with output of shell command
    (shell-command-on-region (point-min) (point-max) "hclfmt" nil t)
    ;; restore cursor position
    (goto-line line)
    (recenter-top-bottom)))

(defun hclfmt-save-hook ()
  (add-hook 'before-save-hook
            (lambda ()
              (progn
                (hclfmt-buffer)
                ;; Continue to save.
                nil))
            nil
            ;; Buffer local hook.
            t))

(add-hook 'hcl-mode-hook 'hclfmt-save-hook)


(load-file "~/.dotfiles/s.el")
(load-file "~/.dotfiles/robot-mode.el")

;; Standard package.el + MELPA setup
;; (See also: https://github.com/milkypostman/melpa#usage)
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)

;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


(global-set-key [f10] 'flycheck-previous-error)
(global-set-key [f11] 'flycheck-next-error)

(require 'flymake-cursor "~/.dotfiles/flymake-cursor")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-pycheckers-max-line-length 258)
 '(flycheck-python-flake8-executable "python3")
 '(flycheck-python-mypy-executable "mypy")
 '(flycheck-python-pycompile-executable "python3")
 '(flycheck-python-pylint-executable "python3")
 '(js-indent-level 2)
 '(magit-diff-refine-hunk (quote all))
 '(magit-diff-section-arguments (quote ("--no-ext-diff")))
 '(package-selected-packages
   (quote
    (protobuf-mode js2-mode terraform-mode hcl-mode bracketed-paste flycheck-mypy isortify blacken yaml-mode bazel-mode dockerfile-mode flycheck-golangci-lint typescript-mode groovy-mode git-commit-insert-issue company gotest flycheck go-projectile git-gutter magit nhexl-mode jedi)))
 '(python-shell-interpreter "python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white")))))

(global-git-gutter-mode +1)


                                        ; GO-lang stuff
; https://github.com/cockroachdb/cockroach/wiki/Ben's-Go-Emacs-setup
; pkg go installation
(setq exec-path (append '("$HOME/.gvm/gos/go1.17.7/bin") exec-path))
(setq exec-path (append '("/opt/go/bin") exec-path))
(setenv "PATH" (concat "$HOME/.gvm/gos/go1.17.7/bin:/usr/local/go/bin:" (getenv "PATH")))

; As-you-type error highlighting
(add-hook 'after-init-hook #'global-flycheck-mode)

(defun my-go-mode-hook ()
      (setq tab-width 2 indent-tabs-mode 1)
      ; eldoc shows the signature of the function at point in the status bar.
      (go-eldoc-setup)
      (local-set-key (kbd "M-.") #'godef-jump)
      (local-set-key (kbd "M-*") 'pop-tag-mark)
      (add-hook 'before-save-hook 'gofmt-before-save)

      ; extra keybindings from https://github.com/bbatsov/prelude/blob/master/modules/prelude-go.el
      (let ((map go-mode-map))
        (define-key map (kbd "C-c a") 'go-test-current-project) ;; current package, really
        (define-key map (kbd "C-c m") 'go-test-current-file)
        (define-key map (kbd "C-c .") 'go-test-current-test)
        (define-key map (kbd "C-c b") 'go-run)))
(add-hook 'go-mode-hook 'my-go-mode-hook)

; Use projectile-test-project in place of 'compile'; assign whatever key you want.
(global-set-key [f9] 'projectile-test-project)

; "projectile" recognizes git repos (etc) as "projects" and changes settings
; as you switch between them.
(projectile-global-mode 1)
(require 'go-projectile)
(go-projectile-tools-add-path)
;; (setq gofmt-command (concat go-projectile-tools-path "/bin/goimports"))
(setq gofmt-args (list "-s"))

; "company" is auto-completion
(require 'company)
(require 'go-mode)
;(require 'company-go)
(add-hook 'go-mode-hook (lambda ()
                          (company-mode)
                          (set (make-local-variable 'company-backends) '(company-go))))

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing



; gotest defines a better set of error regexps for go tests, but it only
; enables them when using its own functions. Add them globally for use in
(require 'compile)
(require 'gotest)
(dolist (elt go-test-compilation-error-regexp-alist-alist)
  (add-to-list 'compilation-error-regexp-alist-alist elt))
(defun prepend-go-compilation-regexps ()
  (dolist (elt (reverse go-test-compilation-error-regexp-alist))
    (add-to-list 'compilation-error-regexp-alist elt t)))
(add-hook 'go-mode-hook 'prepend-go-compilation-regexps)

(load "/usr/share/emacs/site-lisp/clang-format-5.0/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(global-flycheck-mode 1)
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))
