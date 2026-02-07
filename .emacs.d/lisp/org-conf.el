(use-package org
  :ensure t
  :custom
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-fragtog-mode))
  :config
  ;; Babel: caricamento linguaggi
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (C . t)
     (rust . t))))

;; Estetica Moderna
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

;; Org Roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documenti/org-notes"))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n u" . org-roam-ui-mode))
  :config
  (org-roam-db-autosync-mode))

(provide 'org-conf)
