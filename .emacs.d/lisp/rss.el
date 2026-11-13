;;; rss.el --- Elfeed RSS configuration  -*- lexical-binding: t; -*-

(defun my/elfeed-open ()
  "Apri Elfeed con filtro unread recente."
  (interactive)
  (elfeed)
  (elfeed-search-set-filter "@1-week-ago +unread"))

(use-package elfeed
  :bind ("C-c e" . my/elfeed-open)
  :custom
  (elfeed-db-directory (locate-user-emacs-file "elfeed"))
  (elfeed-search-title-max-width 100)
  (elfeed-search-date-format '("%Y-%m-%d" 10 :left))
  (elfeed-show-entry-switch 'display-buffer)
  (elfeed-show-truncate-long-lines nil)
  :config
  ;; Feed
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" blog emacs)
          ("https://elpa.gnu.org/packages/org.xml" emacs extension)
          ("https://rss.arxiv.org/rss/astro-ph" arxiv astrophysics)
          ("https://rss.arxiv.org/rss/cs.AI" arxiv ai)
          ("https://www.staffettaonline.com/rss/RSS_Home.xml" staffetta home)
          ("https://www.staffettaonline.com/rss/RSS_Mercati.xml" staffetta mercato)
          ("https://www.staffettaonline.com/rss/RSS_Cons_Altre_Fonti.xml" staffetta altre)
          ("https://archlinux.org/feeds/news/" arch news)))

  ;; Aggiornamenti: uno dopo l'avvio e uno ogni giorno alle 09:00.
  (run-at-time 300 nil #'elfeed-update)
  (run-at-time "09:00" 86400 #'elfeed-update)

  ;; Salva il DB alla chiusura (focus-out-hook è deprecato).
  (add-hook 'kill-emacs-hook #'elfeed-db-save)

  ;; Keybindings ricerca
  (keymap-set elfeed-search-mode-map "n" #'next-line)
  (keymap-set elfeed-search-mode-map "p" #'previous-line)
  (keymap-set elfeed-search-mode-map "RET" #'elfeed-search-show-entry)
  (keymap-set elfeed-search-mode-map "o" #'elfeed-search-show-entry)
  (keymap-set elfeed-search-mode-map "b" #'elfeed-search-browse-url)
  (keymap-set elfeed-search-mode-map "q" #'quit-window)

  (keymap-set elfeed-search-mode-map "r"
              (lambda ()
                (interactive)
                (let ((entry (elfeed-search-selected)))
                  (elfeed-untag entry 'unread)
                  (elfeed-search-update-entry entry))))

  (keymap-set elfeed-search-mode-map "f u"
              (lambda ()
                (interactive)
                (elfeed-search-set-filter "@1-month-ago +unread")))

  (keymap-set elfeed-search-mode-map "f a"
              (lambda ()
                (interactive)
                (elfeed-search-set-filter "")))

  ;; Mouse
  (keymap-set elfeed-search-mode-map "<mouse-1>" #'elfeed-search-show-entry)
  (keymap-set elfeed-search-mode-map "<double-mouse-1>" #'elfeed-search-show-entry)

  ;; Keybindings visualizzazione
  (keymap-set elfeed-show-mode-map "q" #'kill-current-buffer)
  (keymap-set elfeed-show-mode-map "b" #'elfeed-show-visit)
  (keymap-set elfeed-show-mode-map "n" #'elfeed-show-next)
  (keymap-set elfeed-show-mode-map "p" #'elfeed-show-prev))

(use-package elfeed-goodies
  :after elfeed
  :config
  (elfeed-goodies/setup))

(provide 'rss)
