;;; lisp/elfeed-conf.el --- RSS Reader Moderno

(use-package elfeed
  :ensure t
  :bind (("C-c e" . my/elfeed-simple))
  :custom
  (elfeed-db-directory (locate-user-emacs-file "elfeed"))
  (elfeed-search-title-max-width 100)
  (elfeed-search-date-format '("%Y-%m-%d" 10 :left))
  (elfeed-show-entry-switch 'display-buffer)
  (elfeed-show-truncate-long-lines nil)
  
  :config
  ;; 1. Lista dei Feed
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" blog emacs)
          ("https://elpa.gnu.org/packages/org.xml" emacs extension)
          ("https://rss.arxiv.org/rss/astro-ph" arXiv Astrophysics)
          ("https://rss.arxiv.org/rss/cs.AI" arXiv AI)
          ("https://archlinux.org/feeds/news/" ArchLinux news)))

  ;; 2. Funzioni di interfaccia e filtri
  (defun my/elfeed-simple ()
    "Apri Elfeed con filtri predefiniti."
    (interactive)
    (elfeed)
    (elfeed-search-set-filter "@1-week-ago +unread"))

  ;; 3. Automazione Aggiornamenti
  (run-at-time "09:00" 86400 (lambda () (elfeed-update)))
  (add-hook 'emacs-startup-hook 
            (lambda () (run-at-time 300 nil #'elfeed-update)))

  ;; 4. Gestione Database al focus-out
  (add-hook 'focus-out-hook #'elfeed-db-save)

  ;; 5. Keybindings Locali (Sostituisce i vecchi setup-keys)
  :bind (:map elfeed-search-mode-map
              ("n"   . next-line)
              ("p"   . previous-line)
              ("RET" . elfeed-search-show-entry)
              ("o"   . elfeed-search-show-entry)
              ("b"   . elfeed-search-browse-url)
              ("r"   . (lambda () (interactive) (elfeed-untag (elfeed-search-selected) 'unread) (elfeed-search-update-entry (elfeed-search-selected))))
              ("f u" . (lambda () (interactive) (elfeed-search-set-filter "@1-month-ago +unread")))
              ("f a" . (lambda () (interactive) (elfeed-search-set-filter "")))
              ("q"   . quit-window)
              ([mouse-1] . elfeed-search-show-entry)
              ([double-mouse-1] . elfeed-search-show-entry))

  :bind (:map elfeed-show-mode-map
              ("q" . elfeed-kill-buffer)
              ("b" . elfeed-show-visit)
              ("n" . elfeed-show-next)
              ("p" . elfeed-show-prev)))

;; Pacchetto extra consigliato per rendere i feed più belli
(use-package elfeed-goodies
  :ensure t
  :after elfeed
  :config
  (elfeed-goodies/setup))

(provide 'rss)
