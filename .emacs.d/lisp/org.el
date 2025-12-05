;(use-package org
;  :config
;  (dolist (key '("S-<left>" "S-<right>" "S-<up>" "S-<down>"
;                 "C-S-<left>" "C-S-<right>" "C-S-<up>" "C-S-<down>"))
;    (define-key org-mode-map (kbd key) nil)))
;; Disable org-element cache for non-Org buffers
(setq org-element-use-cache nil)

(use-package org
  :config
  ;; Abilita la modalità di indentazione per un aspetto pulito e gerarchico.
  (org-indent-mode)
  (setq org-startup-indented t)
  
  ;; Imposta i marcatori di enfasi per un aspetto più pulito.
  ;; "*" per il grassetto, "/" per il corsivo, ecc.
  (setq org-hide-emphasis-markers t)

  ;; Abilita l'uso di caratteri speciali per un aspetto più gradevole.
  ;; Ad esempio, "->" diventa una freccia, "alpha" diventa α.
  (setq org-pretty-entities t))

;;;; org babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . nil)
   (R . t)
   (octave . t)
   (python . t)
   (C . t)
   (rust . t)))

;;;; org modern mode
(require 'org-modern)
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;;;; org view
(require 'org-view-mode)
(use-package org-view-mode
  :ensure t)

(defun org-visual-mode () 
  "enable visual mode"
  (interactive)
  (org-modern-mode 1)
  (org-fragtog-mode 1))

(defun org-visual-mode-on () 
  "enable visual mode"
  (interactive)
  (org-view-mode 1)
  (org-modern-mode 1)
  (org-fragtog-mode 1))
  
(defun org-visual-mode-off () 
  "disable visual mode"
  (interactive)
  (org-view-mode -1)
  (org-modern-mode -1)
  (org-fragtog-mode -1))

(add-hook 'org-mode-hook (lambda ()
			   (local-set-key (kbd "C-c C-v") 'org-visual-mode)
                           (local-set-key (kbd "C-c v") 'org-visual-mode-on)
                           (local-set-key (kbd "C-c V") 'org-visual-mode-off)))

;;;; org mode fragtog (math mode)
(add-hook 'org-mode-hook 'org-fragtog-mode)

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
  (org-roam-directory (file-truename "~/Documents/org-notes"))
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
  
(defun org-clock-kill-emacs-query ()
  "Function to handle clock operations before killing Emacs."
  (when (org-clocking-p)
    (org-clock-out)))

;; Attiva l'adattamento delle righe visive per Org Mode
(add-hook 'org-mode-hook 'visual-line-mode)
