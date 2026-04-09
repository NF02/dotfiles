(use-package elfeed
  :ensure t
  :bind (("C-c e" . my/elfeed-open))
  :custom
  (elfeed-db-directory (locate-user-emacs-file "elfeed"))
  (elfeed-search-title-max-width 100)
  (elfeed-search-date-format '("%Y-%m-%d" 10 :left))
  (elfeed-show-entry-switch 'display-buffer)
  (elfeed-show-truncate-long-lines nil)
  :config

  ;; --------------------------------------------------
  ;; Feed list
  ;; --------------------------------------------------
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" blog emacs)
          ("https://elpa.gnu.org/packages/org.xml" emacs extension)
          ("https://rss.arxiv.org/rss/astro-ph" arxiv astrophysics)
          ("https://rss.arxiv.org/rss/cs.AI" arxiv ai)
          ("https://archlinux.org/feeds/news/" arch news)))

  ;; --------------------------------------------------
  ;; Entry point
  ;; --------------------------------------------------
  (defun my/elfeed-open ()
    "Apri Elfeed con filtro unread recente."
    (interactive)
    (elfeed)
    (elfeed-search-set-filter "@1-week-ago +unread"))

  ;; --------------------------------------------------
  ;; Auto update
  ;; --------------------------------------------------
  (run-at-time "09:00" 86400 #'elfeed-update)

  (add-hook 'emacs-startup-hook
            (lambda ()
              (run-at-time 300 nil #'elfeed-update)))

  ;; Salva DB quando perdi focus
  (add-hook 'focus-out-hook #'elfeed-db-save)

  ;; --------------------------------------------------
  ;; Keybindings search mode
  ;; --------------------------------------------------
  (define-key elfeed-search-mode-map (kbd "n") #'next-line)
  (define-key elfeed-search-mode-map (kbd "p") #'previous-line)
  (define-key elfeed-search-mode-map (kbd "RET") #'elfeed-search-show-entry)
  (define-key elfeed-search-mode-map (kbd "o") #'elfeed-search-show-entry)
  (define-key elfeed-search-mode-map (kbd "b") #'elfeed-search-browse-url)

  (define-key elfeed-search-mode-map (kbd "r")
    (lambda ()
      (interactive)
      (let ((entry (elfeed-search-selected)))
        (elfeed-untag entry 'unread)
        (elfeed-search-update-entry entry))))

  (define-key elfeed-search-mode-map (kbd "f u")
    (lambda ()
      (interactive)
      (elfeed-search-set-filter "@1-month-ago +unread")))

  (define-key elfeed-search-mode-map (kbd "f a")
    (lambda ()
      (interactive)
      (elfeed-search-set-filter "")))

  (define-key elfeed-search-mode-map (kbd "q") #'quit-window)

  ;; Mouse support
  (define-key elfeed-search-mode-map [mouse-1] #'elfeed-search-show-entry)
  (define-key elfeed-search-mode-map [double-mouse-1] #'elfeed-search-show-entry)

  ;; --------------------------------------------------
  ;; Keybindings show mode
  ;; --------------------------------------------------
  (define-key elfeed-show-mode-map (kbd "q") #'elfeed-kill-buffer)
  (define-key elfeed-show-mode-map (kbd "b") #'elfeed-show-visit)
  (define-key elfeed-show-mode-map (kbd "n") #'elfeed-show-next)
  (define-key elfeed-show-mode-map (kbd "p") #'elfeed-show-prev))

;; --------------------------------------------------
;; UI migliorata
;; --------------------------------------------------

(use-package elfeed-goodies
  :ensure t
  :after elfeed
  :config
  (elfeed-goodies/setup))

(provide 'elfeed-conf)
