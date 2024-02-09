(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(load-theme 'gruvbox-light-soft t)
					; ido mode
;; prev list
(setq completion-auto-help 'visible)
;; autocomp by selection
(setq completion-auto-select 'second-tab)

(defun renz/sort-by-alpha-length (elems)
  "Sort ELEMS first alphabetically, then by length."
  (sort elems (lambda (c1 c2)
                (or (string-version-lessp c1 c2)
                    (< (length c1) (length c2))))))

(defun renz/sort-by-history (elems)
  "Sort ELEMS by minibuffer history.
Use `mct-sort-sort-by-alpha-length' if no history is available."
  (if-let ((hist (and (not (eq minibuffer-history-variable t))
                      (symbol-value minibuffer-history-variable))))
      (minibuffer--sort-by-position hist elems)
    (renz/sort-by-alpha-length elems)))

(defun renz/completion-category ()
  "Return completion category."
  (when-let ((window (active-minibuffer-window)))
    (with-current-buffer (window-buffer window)
      (completion-metadata-get
       (completion-metadata (buffer-substring-no-properties
                             (minibuffer-prompt-end)
                             (max (minibuffer-prompt-end) (point)))
                            minibuffer-completion-table
                            minibuffer-completion-predicate)
       'category))))

(defun renz/sort-multi-category (elems)
  "Sort ELEMS per completion category."
  (pcase (renz/completion-category)
    ('nil elems) ; no sorting
    ('kill-ring elems)
    ('project-file (renz/sort-by-alpha-length elems))
    (_ (renz/sort-by-history elems))))

(setq completions-sort #'renz/sort-multi-category)

;; Up/down when completing in the minibuffer
(define-key minibuffer-local-map (kbd "C-p") #'minibuffer-previous-completion)
(define-key minibuffer-local-map (kbd "C-n") #'minibuffer-next-completion)

;; Up/down when competing in a normal buffer
(define-key completion-in-region-mode-map (kbd "C-p") #'minibuffer-previous-completion)
(define-key completion-in-region-mode-map (kbd "C-n") #'minibuffer-next-completion)

					; end ido
;; ------------------------------------------------------------------
;; plugin
;; ------------------------------------------------------------------

; il repo esterno melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; determine the load path dirs
;; as relative to the location of this file
(defvar dotfiles-dir "~/.emacs.d/"
  "The root Emacs Lisp source folder")

;; pdf tools
(require 'pdf-tools)
(use-package pdf-tools
  :init
  (pdf-tools-install))

;; AUCtex
(use-package auctex
  :ensure t
  :defer t)
;;;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;;;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;; auto-complete
(require 'auto-complete)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)


;; org-mode
;;;; ox contrib
(use-package org-contrib)

;;;; org modern mode
(require 'org-modern)
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;; Load elfeed-org
(require 'elfeed-org)

;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=
(elfeed-org)

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))

;; file manager
(require 'dirvish)
(dirvish-override-dired-mode)

;; terminal
(use-package vterm
    :ensure t)

; external repo by straightEL

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
       (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


