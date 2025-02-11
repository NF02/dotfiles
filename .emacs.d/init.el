(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; trasparent
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

(setq inhibit-startup-screen t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; ------------------------------------------------------------------
;; plugin
;; ------------------------------------------------------------------

; il repo esterno melpa
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
			  ("org" . "https://orgmode.org/elpa/")
))

(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; determine the load path dirs
;; as relative to the location of tris file
(defvar dotfiles-dir "~/.emacs.d/"
  "The root Emacs Lisp source folder")

;; ido mode
(ido-mode t)

;; lang check tool
(if (file-exists-p "/usr/bin/hunspell")
    (progn
      (setq ispell-program-name "hunspell")
      (eval-after-load "ispell"
        '(progn (defun ispell-get-coding-system () 'utf-8)))))

(global-set-key [f6] 'flyspell-mode)

;; GUI settings
(load "~/.emacs.d/lisp/gui.el")

;; LaTeX settings
(load "~/.emacs.d/lisp/latex.el")

;; org-mode settings
(load "~/.emacs.d/lisp/org.el")

;; dev settings
(load "~/.emacs.d/lisp/dev.el")
