;; Rimozione degli elementi grafici
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

(global-set-key (kbd "TAB") 'self-insert-command)

;; evidenzia riga
(global-hl-line-mode 1)

;; numero per riga
(global-linum-mode t)

;; il repo esterno
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; evil
(use-package evil
  :ensure t
  :init
  (evil-mode 1))

;; which-key
(use-package which-key
  :ensure t
  :init
  (which-key-mode 1))

;; beacon
(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

;; ido mode "modalità interattiva"
(require 'ido)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'alway)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))

;; auctex
(use-package auctex
  :ensure t
  :defer t)

;; org mode
(use-package ox-reveal)
(use-package org-contrib)

;; pdf view
(setq TeX-PDF-mode t)
(use-package pdf-tools
   :pin manual
   :config
   (pdf-tools-install)
   (setq-default pdf-view-display-size 'fit-width)
   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
   :custom
   (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

;; powerline
(require 'powerline)
(powerline-default-theme)

;; trasparenza
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))

(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(90 . 90) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;; latex
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
             '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(setq org-latex-listings 't)

;; themes
(use-package solarized-theme
:ensure t
:config
(load-theme 'solarized-dark-high-contrast t))
