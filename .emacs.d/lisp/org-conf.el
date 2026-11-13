;;; org-conf.el --- Org-mode configuration  -*- lexical-binding: t; -*-

;; --------------------------------------------------
;; 1. Percorsi
;; --------------------------------------------------

(defvar my/org-directory (expand-file-name "~/Documenti/org-notes"))

;; Backend EPUB locale (se presente).
(add-to-list 'load-path (expand-file-name "~/repos/ox-epub3"))

;; --------------------------------------------------
;; 2. Impostazioni Org di base
;; --------------------------------------------------

(setq org-hide-emphasis-markers t
      org-startup-folded 'content
      org-return-follows-link t)

;; --------------------------------------------------
;; 3. Aspetto
;; --------------------------------------------------

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-mode . org-indent-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-star 'replace)
  (org-modern-replace-stars '("◉" "○" "◈" "◇" "∙" "◦"))
  (org-modern-fold-stars '(("⮞" . "⮟")
                           ("⮚" . "⮛")
                           ("▶" . "▼")
                           ("▷" . "▽")))
  (org-modern-hide-stars 'leading)
  (org-modern-table nil)
  (org-modern-keyword 1)
  (org-modern-todo 1)
  :config
  (defface org-level-9
    '((t :inherit org-level-1 :weight bold))
    "Face per livello 9."
    :group 'org-faces)
  (dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4
                  org-level-5 org-level-6 org-level-7 org-level-8))
    (set-face-attribute face nil :weight 'bold)))

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

;; --------------------------------------------------
;; 3b. Anteprime LaTeX
;; --------------------------------------------------

;; L'export usa lualatex, quindi Org include `fontspec' nel preambolo delle
;; anteprime.  I processi dvipng/dvisvgm compilano pero' con `latex' (pdfTeX),
;; che non supporta fontspec: le nuove anteprime fallivano.  `xelatex'
;; supporta fontspec e produce SVG, scalabili senza perdita di qualita'.
(setq org-preview-latex-default-process 'xelatex)

(defun my/org-latex-preview--base-scale ()
  "Rapporto tra il font di default e i 10pt usati da LaTeX."
  (let ((height (face-attribute 'default :height)))
    (if (and (numberp height) (> height 3))
        (/ height 100.0)
      1.0)))

(defun my/org-latex-preview--text-scale ()
  "Fattore di scala corrente delle anteprime LaTeX."
  (* (my/org-latex-preview--base-scale)
     (if (bound-and-true-p text-scale-mode)
         (expt text-scale-mode-step text-scale-mode-amount)
       1.0)
     (or (bound-and-true-p my/org-presentation-current-scale) 1.0)))

(defun my/org-latex-preview--scale-overlay (overlay scale)
  "Imposta SCALE sull'immagine dell'overlay OVERLAY."
  (let ((display (overlay-get overlay 'display)))
    (when (and (consp display) (eq (car display) 'image))
      (setcdr display
              (plist-put (copy-sequence (cdr display)) :scale scale)))))

(defun my/org-latex-preview-refresh-scaling ()
  "Allinea le anteprime LaTeX alla dimensione corrente del testo."
  (when (and (derived-mode-p 'org-mode)
             (display-graphic-p))
    (let ((scale (my/org-latex-preview--text-scale)))
      (dolist (overlay (overlays-in (point-min) (point-max)))
        (when (eq (overlay-get overlay 'org-overlay-type) 'org-latex-overlay)
          (my/org-latex-preview--scale-overlay overlay scale))))))

(dolist (command '(org-latex-preview text-scale-mode
                   text-scale-increase text-scale-decrease
                   text-scale-set text-scale-adjust))
  (unless (advice-member-p #'my/org-latex-preview-refresh-scaling command)
    (advice-add command :after #'my/org-latex-preview-refresh-scaling)))

(defun my/org-mode-setup ()
  "Setup minimale dei buffer Org."
  (visual-line-mode 1)
  ;; Ricalcola l'adattamento della slide a ogni cambio di slide.
  (add-hook 'org-tree-slide-after-narrow-hook
            #'my/org-presentation-fit-slide nil t))

(add-hook 'org-mode-hook #'my/org-mode-setup)

;; --------------------------------------------------
;; 4. Org-roam
;; --------------------------------------------------

(use-package org-roam
  :custom
  (org-roam-directory my/org-directory)
  (org-roam-database-connector 'sqlite-builtin)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n d" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :after org-roam
  :commands org-roam-ui-mode
  :bind ("C-c n u" . org-roam-ui-mode)
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start t))

;; --------------------------------------------------
;; 5. Agenda
;; --------------------------------------------------

(use-package org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
  :custom
  (org-super-agenda-groups
   '((:name "Oggi" :time-grid t :date today :order 1)
     (:name "Importante" :priority "A" :order 2)
     (:name "Progetti" :tag "project" :order 3))))

;; --------------------------------------------------
;; 6. Init cartelle (solo quando Org viene caricato)
;; --------------------------------------------------

(defun my/org-init-folders ()
  "Crea le cartelle di base di Org, se mancano."
  (dolist (dir (list my/org-directory
                     (expand-file-name "daily" my/org-directory)
                     (expand-file-name "projects" my/org-directory)))
    (unless (file-directory-p dir)
      (make-directory dir t))))

(with-eval-after-load 'org
  (my/org-init-folders))

;; --------------------------------------------------
;; 7. Babel
;; --------------------------------------------------

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (emacs-lisp . t)
     (R . t)
     (C . t)
     (python . t))))

;; --------------------------------------------------
;; 8. Export
;; --------------------------------------------------

(use-package org-re-reveal
  :commands (org-re-reveal)
  :config
  (setq org-re-reveal-root (expand-file-name "~/repos/reveal.js/")
        org-re-reveal-hlevel 2
        org-re-reveal-theme "black"
        org-re-reveal-slide-number "c/t"))

(with-eval-after-load 'ox-latex
  (setq org-latex-pdf-process
        '("latexmk -f -pdf -pdflatex='lualatex %%O %%S' -interaction=nonstopmode -output-directory=%o %f"))
  (setq org-latex-compiler "lualatex"))

;; I backend di export vengono caricati solo quando serve esportare.
(with-eval-after-load 'ox
  (require 'ox-pandoc)
  (setq org-epub3-default-language "it")
  (require 'ox-epub3 nil t))

;; --------------------------------------------------
;; 9. Lettura EPUB
;; --------------------------------------------------

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :custom
  (nov-text-width 80)
  :config
  (setq nov-unzip-program (executable-find "bsdtar")
        nov-unzip-args '("-xC" directory "-f" filename))
  (add-hook 'nov-mode-hook
            (lambda ()
              (face-remap-add-relative 'shr-text
                                       :family "OpenDyslexicAlt Nerd Font"
                                       :height 1.1)))
  (add-hook 'nov-mode-hook #'visual-line-mode))

(provide 'org-conf)
