;; --------------------------------------------------
;; 1. Percorsi
;; --------------------------------------------------

(defvar my/org-directory (expand-file-name "~/Documenti/org-notes"))
(defvar my/org-agenda-files (list my/org-directory))

;; --------------------------------------------------
;; 2. Core Org
;; --------------------------------------------------

(use-package org-modern
  :ensure t
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-mode . org-indent-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-star 'replace)
  (org-modern-replace-stars '("●" "○" "■" "□" "▲" "△" "◆" "◇" "○"))
  (org-modern-fold-stars '(("⮞" . "⮟")
                           ("⮚" . "⮛")
                           ("▶" . "▼")
                           ("▷" . "▽")))
  (org-modern-hide-stars 'leading)
  (org-modern-table nil)
  (org-modern-keyword nil)
  (org-modern-todo nil)
  :config
  ;; Face livello 9 (necessaria)
  (defface org-level-9
    '((t :inherit org-level-1 :weight bold))
    "Face per livello 9"
    :group 'org-faces)

  ;; Rendi i titoli più leggibili
  (dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4
                  org-level-5 org-level-6 org-level-7 org-level-8))
    (set-face-attribute face nil :weight 'bold)))

(use-package org-fragtog
  :ensure t
  :after org
  :hook (org-mode . org-fragtog-mode))

;; --------------------------------------------------
;; 3. Org-roam
;; --------------------------------------------------

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

;; --------------------------------------------------
;; 4. Agenda
;; --------------------------------------------------

(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Oggi" :time-grid t :date today :order 1)
          (:name "Importante" :priority "A" :order 2)
          (:name "Progetti" :tag "project" :order 3))))

;; --------------------------------------------------
;; 5. Org base setup
;; --------------------------------------------------

(defun my/org-mode-setup ()
  "Setup minimale senza toccare font."
  (visual-line-mode 1))

(add-hook 'org-mode-hook #'my/org-mode-setup)

;; --------------------------------------------------
;; 6. Init cartelle
;; --------------------------------------------------

(defun my/org-init-folders ()
  (dolist (dir (list my/org-directory
                     (expand-file-name "daily" my/org-directory)
                     (expand-file-name "projects" my/org-directory)))
    (unless (file-directory-p dir)
      (make-directory dir t))))

(my/org-init-folders)

;; --------------------------------------------------
;; 7. Presentazione
;; --------------------------------------------------

(use-package visual-fill-column
  :ensure t
  :custom
  (visual-fill-column-width 100)
  (visual-fill-column-center-text t))

(use-package org-tree-slide
  :ensure t
  :after (org visual-fill-column)
  :bind (:map org-tree-slide-mode-map
              ("<right>" . org-tree-slide-move-next-tree)
              ("<left>" . org-tree-slide-move-previous-tree)
              ("C-q" . org-tree-slide-mode))
  :hook (org-tree-slide-mode
         . (lambda ()
             (if org-tree-slide-mode
                 (progn
                   (setq visual-fill-column-width 110)
                   (setq visual-fill-column-center-text t)
                   (visual-fill-column-mode 1)

                   (set-frame-parameter nil 'internal-border-width 40)

                   (setq-local mode-line-format nil)

                   (setq-local my-slide-remap
                               (face-remap-add-relative 'default :height 1.5))

                   (force-mode-line-update))
               (progn
                 (visual-fill-column-mode 0)
                 (set-frame-parameter nil 'internal-border-width 0)
                 (kill-local-variable 'mode-line-format)
                 (face-remap-remove-relative my-slide-remap)
                 (force-mode-line-update)))))
  :config
  (setq org-tree-slide-header t
        org-tree-slide-slide-in t
        org-tree-slide-breadcrumbs " > "))

(provide 'org-conf)
