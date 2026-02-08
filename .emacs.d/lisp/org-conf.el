;;; org-conf.el --- Configurazione Org pulita e senza cambi font -*- lexical-binding: t; -*-

;; =========================
;; 1. Percorsi e Variabili
;; =========================
(defvar my/org-directory (expand-file-name "~/Documenti/org-notes"))
(defvar my/org-agenda-files (list my/org-directory))

;; =========================
;; 2. Core Org Mode
;; =========================
(use-package org
  :ensure t
  :defer t 
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :custom
  (org-directory my/org-directory)
  (org-agenda-files my/org-agenda-files)
  ;; Visualizzazione (Mantiene il font di default)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-adapt-indentation nil) ; Evita di aggiungere spazi fisici ai file
  ;; Editing
  (org-special-ctrl-a/e t)
  (org-M-RET-may-split-line nil)
  (org-src-fontify-natively t)
  (org-confirm-babel-evaluate nil)
  ;; Agenda & Capture
  (org-agenda-span 7)
  (org-agenda-window-setup 'current-window)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (C . t) (rust . t) (shell . t)))
  (setq org-babel-python-command "python3"))

;; =========================
;; 3. Estetica (Solo Simboli)
;; =========================
(use-package org-modern
  :ensure t
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  ;; Non tocchiamo i font, solo le icone degli elenchi e dei titoli
  (org-modern-star '("◉" "○" "◈" "◇" "✚" "✜" "✖" "✙" "✦"))
  (org-modern-hide-stars 'leading)
  (org-modern-table nil)    ; Mantiene le tabelle classiche (più facili da editare)
  (org-modern-keyword nil)  ; Non trasforma #+title in etichette grafiche
  (org-modern-todo nil))    ; Lascia i TODO testuali per non cambiare font

(use-package org-fragtog
  :ensure t
  :after org
  :hook (org-mode . org-fragtog-mode))

;; =========================
;; 4. Org Roam (Zettelkasten)
;; =========================
(use-package org-roam
  :ensure t
  :after org
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
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; =========================
;; 5. Agenda Potenziata
;; =========================
(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Oggi" :time-grid t :date today :order 1)
          (:name "Importante" :priority "A" :order 2)
          (:name "Progetti" :tag "project" :order 3))))

(defun my/org-mode-setup ()
  "Configurazione base senza forzare font."
  (visual-line-mode 1)) ; Wrap delle linee senza spezzare le parole

(add-hook 'org-mode-hook #'my/org-mode-setup)

;; =========================
;; 7. Init Cartelle
;; =========================
(defun my/org-init-folders ()
  (dolist (dir (list my/org-directory 
                     (concat my/org-directory "/daily")
                     (concat my/org-directory "/projects")))
    (unless (file-exists-p dir) (make-directory dir t))))

(my/org-init-folders)
;; =========================
;; 8. Presentazione
;; =========================
(use-package org-tree-slide
  :ensure t
  :after org
  :bind (:map org-tree-slide-mode-map
              ("<right>" . org-tree-slide-move-next-tree)
              ("<left>" . org-tree-slide-move-previous-tree)
              ("C-q" . org-tree-slide-mode))
  :hook ((org-tree-slide-mode . (lambda ()
                                  (visual-fill-column-mode 1)
                                  (setq-local face-remapping-alist '((default (:height 1.5))))))
         (org-tree-slide-mode-quit . (lambda ()
                                       (visual-fill-column-mode 0)
                                       (setq-local face-remapping-alist nil))))
  :config
  (setq org-tree-slide-header nil         ;; Rimuove l'intestazione fastidiosa
        org-tree-slide-slide-in t         ;; Effetto scorrimento
        org-tree-slide-breadcrumbs nil))  ;; Nasconde il percorso dei titoli

;; Per centrare il testo durante la presentazione (fondamentale)
(use-package visual-fill-column
  :ensure t
  :config
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t))
(provide 'org-conf)
