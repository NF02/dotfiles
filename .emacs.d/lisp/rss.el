;; =============================================
;; Elfeed RSS Reader - Configurazione Semplice
;; =============================================

(require 'elfeed)
(require 'elfeed-show)

;; Database location
(setq elfeed-db-directory (locate-user-emacs-file "elfeed"))

;; Feed list
(setq elfeed-feeds
      '(;; Emacs end extension
	("http://nullprogram.com/feed/" blog emacs)
        ("https://elpa.gnu.org/packages/org.xml" emacs extension)
	;; ArXiv archive
        ("https://rss.arxiv.org/rss/astro-ph" arXiv Astrophysics)
	("https://rss.arxiv.org/rss/cs.AI" arXiv AI)
	("https://rss.arxiv.org/rss/econ" arXiv Economics)
	("https://rss.arxiv.org/rss/eess" arXiv Electrical-Engineering)
	("https://rss.arxiv.org/rss/math" arXiv Mathematics)
	("https://rss.arxiv.org/rss/physics" arXiv Physics)
	("https://rss.arxiv.org/rss/q-bio" arXiv Quantitative-Biology)
	("https://rss.arxiv.org/rss/stat" arXiv Statistics)
	;; arch linux
	("https://archlinux.org/feeds/news/" ArchLinux news)
	))

;; === COMANDI SEMPLIFICATI ===
(defun my/elfeed-simple ()
  "Apri Elfeed con interfaccia semplificata."
  (interactive)
  (elfeed)
  (elfeed-search-set-filter "@1-week-ago +unread"))

;; === KEYBINDING SEMPLICE ===
(global-set-key (kbd "C-c e") 'my/elfeed-simple)

;; === IMPOSTAZIONI BASE ===
(setq elfeed-search-title-max-width 100
      elfeed-search-date-format '("%Y-%m-%d" 10 :left)
      elfeed-show-entry-switch 'display-buffer
      elfeed-show-entry-delete 'delete-window
      elfeed-show-truncate-long-lines nil)

;; === INTERAZIONE CON MOUSE ===
(defun my/elfeed-mouse-setup ()
  "Configurazione per interazione mouse in Elfeed."
  ;; Click sinistro per aprire articolo
  (define-key elfeed-search-mode-map [mouse-1] 'elfeed-search-show-entry)
  (define-key elfeed-show-mode-map [mouse-1] 'mouse-set-point)
  
  ;; Click destro per menu contestuale
  (define-key elfeed-search-mode-map [mouse-3] 
    (lambda (event)
      (interactive "e")
      (mouse-set-point event)
      (elfeed-search-popup-menu)))
  
  ;; Scroll con rotella mouse
  (define-key elfeed-search-mode-map [wheel-up] 'scroll-down-command)
  (define-key elfeed-search-mode-map [wheel-down] 'scroll-up-command)
  (define-key elfeed-show-mode-map [wheel-up] 'scroll-down-command)
  (define-key elfeed-show-mode-map [wheel-down] 'scroll-up-command)
  
  ;; Doppio click per aprire
  (define-key elfeed-search-mode-map [double-mouse-1] 'elfeed-search-show-entry))

(add-hook 'elfeed-search-mode-hook 'my/elfeed-mouse-setup)
(add-hook 'elfeed-show-mode-hook 'my/elfeed-mouse-setup)

;; === AGGIORNAMENTO AUTOMATICO GIORNALIERO ===
(defun my/elfeed-daily-update ()
  "Aggiorna tutti i feed RSS una volta al giorno."
  (interactive)
  (message "Aggiornamento giornaliero feed RSS in corso...")
  (elfeed-update))

;; Programma aggiornamento giornaliero alle 9:00
(run-at-time "09:00" 86400 'my/elfeed-daily-update)

;; Aggiorna anche all'avvio di Emacs
(add-hook 'emacs-startup-hook 
          (lambda () 
            (run-at-time 300 nil 'my/elfeed-daily-update)))

;; === KEYBINDING LOCALI PER ELFEED-SEARCH ===
(defun my/elfeed-search-keys-setup ()
  "Configura keybinding locali per elfeed-search."
  ;; Navigazione
  (define-key elfeed-search-mode-map (kbd "n") 'next-line)
  (define-key elfeed-search-mode-map (kbd "p") 'previous-line)
  (define-key elfeed-search-mode-map (kbd "SPC") 'scroll-up-command)
  (define-key elfeed-search-mode-map (kbd "S-SPC") 'scroll-down-command)
  
  ;; Apertura articoli
  (define-key elfeed-search-mode-map (kbd "RET") 'elfeed-search-show-entry)
  (define-key elfeed-search-mode-map (kbd "o") 'elfeed-search-show-entry)
  (define-key elfeed-search-mode-map (kbd "b") 'elfeed-search-browse-url)
  
  ;; Gestione articoli
  (define-key elfeed-search-mode-map (kbd "r") 'my/elfeed-mark-read)
  (define-key elfeed-search-mode-map (kbd "u") 'my/elfeed-mark-unread)
  (define-key elfeed-search-mode-map (kbd "s") 'elfeed-search-live-filter)
  
  ;; Aggiornamento feed
  (define-key elfeed-search-mode-map (kbd "g") 'elfeed-update)
  (define-key elfeed-search-mode-map (kbd "G") 'elfeed-search-fetch)
  
  ;; Filtri
  (define-key elfeed-search-mode-map (kbd "f u") 'my/elfeed-show-unread)
  (define-key elfeed-search-mode-map (kbd "f a") 'my/elfeed-show-all)
  (define-key elfeed-search-mode-map (kbd "f e") 'my/elfeed-show-emacs)
  (define-key elfeed-search-mode-map (kbd "f r") 'my/elfeed-show-arxiv)
  
  ;; Uscita
  (define-key elfeed-search-mode-map (kbd "q") 'quit-window))

;; === KEYBINDING LOCALI PER ELFEED-SHOW ===
(defun my/elfeed-show-keys-setup ()
  "Configura keybinding locali per elfeed-show."
  ;; Navigazione articolo
  (define-key elfeed-show-mode-map (kbd "SPC") 'scroll-up-command)
  (define-key elfeed-show-mode-map (kbd "S-SPC") 'scroll-down-command)
  (define-key elfeed-show-mode-map (kbd "n") 'elfeed-show-next)
  (define-key elfeed-show-mode-map (kbd "p") 'elfeed-show-prev)
  
  ;; Azioni
  (define-key elfeed-show-mode-map (kbd "b") 'elfeed-show-visit)
  (define-key elfeed-show-mode-map (kbd "r") 'my/elfeed-show-mark-read)
  (define-key elfeed-show-mode-map (kbd "q") 'elfeed-kill-buffer)
  
  ;; Navigazione tra articoli
  (define-key elfeed-show-mode-map (kbd "N") 'my/elfeed-show-next)
  (define-key elfeed-show-mode-map (kbd "P") 'my/elfeed-show-prev))

;; Applica le configurazioni keybinding
(add-hook 'elfeed-search-mode-hook 'my/elfeed-search-keys-setup)
(add-hook 'elfeed-show-mode-hook 'my/elfeed-show-keys-setup)

;; === FUNZIONI PER GESTIONE ARTICOLI ===
(defun my/elfeed-mark-read ()
  "Marca l'articolo selezionato come letto."
  (interactive)
  (when (elfeed-search-selected)
    (elfeed-untag (elfeed-search-selected) 'unread)
    (elfeed-search-update-entry (elfeed-search-selected))))

(defun my/elfeed-mark-unread ()
  "Marca l'articolo selezionato come non letto."
  (interactive)
  (when (elfeed-search-selected)
    (elfeed-tag (elfeed-search-selected) 'unread)
    (elfeed-search-update-entry (elfeed-search-selected))))

(defun my/elfeed-show-mark-read ()
  "Marca l'articolo corrente come letto e chiudi buffer."
  (interactive)
  (when elfeed-show-entry
    (elfeed-untag elfeed-show-entry 'unread)
    (elfeed-kill-buffer)))

;; === FUNZIONI PER FILTRI RAPIDI ===
(defun my/elfeed-show-unread ()
  "Mostra solo articoli non letti."
  (interactive)
  (elfeed-search-set-filter "@1-month-ago +unread"))

(defun my/elfeed-show-all ()
  "Mostra tutti gli articoli."
  (interactive)
  (elfeed-search-set-filter ""))

(defun my/elfeed-show-emacs ()
  "Mostra solo articoli Emacs."
  (interactive)
  (elfeed-search-set-filter "+emacs"))

(defun my/elfeed-show-arxiv ()
  "Mostra solo articoli ArXiv."
  (interactive)
  (elfeed-search-set-filter "+arXiv"))

;; === NAVIGAZIONE ARTICOLI IN SHOW MODE ===
(defun my/elfeed-show-next ()
  "Vai al prossimo articolo."
  (interactive)
  (let ((entries (elfeed-search-entries)))
    (when entries
      (let ((current-index (cl-position elfeed-show-entry entries)))
        (when current-index
          (let ((new-index (+ current-index 1)))
            (when (< new-index (length entries))
              (elfeed-show-entry (nth new-index entries)))))))))

(defun my/elfeed-show-prev ()
  "Vai all'articolo precedente."
  (interactive)
  (let ((entries (elfeed-search-entries)))
    (when entries
      (let ((current-index (cl-position elfeed-show-entry entries)))
        (when current-index
          (let ((new-index (- current-index 1)))
            (when (>= new-index 0)
              (elfeed-show-entry (nth new-index entries)))))))))

;; === MENU CONTESTUALE MOUSE ===
(defun elfeed-search-popup-menu ()
  "Menu contestuale per Elfeed."
  (interactive)
  (popup-menu
   '("Azioni Elfeed"
     ["Apri articolo" elfeed-search-show-entry]
     ["Apri nel browser" elfeed-search-browse-url]
     ["Marca come letto" my/elfeed-mark-read]
     ["Marca come non letto" my/elfeed-mark-unread]
     ["---" nil]
     ["Aggiorna feed" elfeed-update]
     ["Mostra non letti" my/elfeed-show-unread]
     ["Mostra tutti" my/elfeed-show-all]
     ["---" nil]
     ["Esci" quit-window])))

;; === MESSAGGIO DI BENVENUTO ===
(defun my/elfeed-welcome-message ()
  "Mostra messaggio di benvenuto."
  (message "Elfeed pronto! Click su un articolo per leggerlo. 'q' per uscire."))

(add-hook 'elfeed-search-mode-hook 'my/elfeed-welcome-message)

;; === AUTO-SALVATAGGIO ===
(defun my/elfeed-auto-save ()
  "Salva automaticamente il database Elfeed."
  (when (and (derived-mode-p 'elfeed-search-mode)
             (not (active-minibuffer-window)))
    (elfeed-db-save)))

(add-hook 'focus-out-hook 'my/elfeed-auto-save)
