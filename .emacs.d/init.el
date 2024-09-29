(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; trasparent
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

(setq inhibit-startup-screen t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

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

;; theme
(load-theme 'timu-spacegrey t)

;; ido mode
(ido-mode t)


;; which key
(require 'which-key)
(which-key-mode)
(which-key-setup-minibuffer)

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


;; org-mode
(use-package org
  :config
  (unbind-key "S-<left>" org-mode-map)
  (unbind-key "S-<right>" org-mode-map)
  (unbind-key "S-<up>" org-mode-map)
  (unbind-key "S-<down>" org-mode-map)
  (unbind-key "C-S-<left>" org-mode-map)
  (unbind-key "C-S-<right>" org-mode-map)
  (unbind-key "C-S-<up>" org-mode-map)
  (unbind-key "C-S-<down>" org-mode-map)
  )
;;;; org contrib
(use-package org-contrib)

;;;; org modern mode
(require 'org-modern)
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;;;; org mode convert reveal.js
(require 'org-re-reveal)
(setq org-re-reveal-root "file:///home/nick/repos/reveal.js")

;;;; org mode present
(require 'org-tree-slide)

(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree)
  )
;;;; org roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documenti/org-notes"))
  (org-roam-complete-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
	 ("C-c n u" . org-roam-ui-mode)
	 :map org-mode-map
	 ("C-M-i"          . completion-at-point))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;; elfeed-org
(require 'elfeed)

;; Octave
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1)))
	  'display-line-numbers-mode)

;; powerline
(require 'powerline)
(powerline-default-theme)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; vterm
(require 'vterm)
(require 'vterm-toggle)
(global-set-key [C-f5] 'vterm-toggle-cd)

;; neotree
(require 'neotree)
(global-set-key [f5] 'neotree-toggle)
(global-set-key (kbd "C-c r") 'neotree-refresh)

;; gnu cobol
(require 'cobol-mode)
(setq auto-mode-alist
      (append
       '(("\\.cob\\'" . cobol-mode)
         ("\\.cbl\\'" . cobol-mode)
         ("\\.cpy\\'" . cobol-mode))
       auto-mode-alist))

;; slime
(require 'slime)
(setq inferior-lisp-program "sbcl")

;; processing
(setq processing-location "~/.local/processing-4.3/processing-java")
(setq processing-application-dir "~/.local/processing-4.3/processing")
(setq processing-sketchbook-dir "~/Documenti/processing")

;; eclim
(require 'eclim)
(setq eclimd-autostart t)

(defun my-java-mode-hook ()
    (eclim-mode t))

(add-hook 'java-mode-hook 'my-java-mode-hook)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

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


(straight-use-package
  '(app-launcher :type git :host github :repo "SebastienWae/app-launcher"))

;; load external elisp script
  (let* ((path (expand-file-name "lisp" user-emacs-directory))
         (local-pkgs (mapcar 'file-name-directory (directory-files-recursively path "\\.el$"))))
    (if (file-accessible-directory-p path)
        (mapc (apply-partially 'add-to-list 'load-path) local-pkgs)
      (make-directory path :parents)))
