;;; gui.el --- Graphical UI configuration  -*- lexical-binding: t; -*-

(declare-function company-complete-selection "company")
(declare-function company-select-next "company")
(declare-function company-select-previous "company")

;; --------------------------------------------------
;; 1. Font e temi
;; --------------------------------------------------

(set-face-attribute 'default nil :font "OpenDyslexicM Nerd Font-10")

(setq custom-safe-themes t)

(use-package doom-themes
  :demand t)

(use-package auto-dark
  :demand t
  :custom
  (auto-dark-themes '((doom-outrun-electric) (doom-gruvbox-light)))
  ;; Fallback: se il portal non è disponibile, ricontrolla ogni 2s.
  (auto-dark-polling-interval-seconds 2)
  :config
  ;; Sotto Sway auto-dark non riconosce il desktop e sceglierebbe un metodo
  ;; di rilevamento sbagliato. Se il portal è attivo, usa il metodo D-Bus:
  ;; riceve SettingChanged per org.freedesktop.appearance/color-scheme
  ;; (istantaneo), lo stesso canale usato da GTK e Qt.
  (require 'dbus nil t)
  (when (member "org.freedesktop.portal.Desktop"
                (ignore-errors (dbus-list-activatable-names :session)))
    (setq auto-dark-detection-method 'dbus))
  (auto-dark-mode 1))

;; Sincronizza Emacs con darkman. Viene chiamata da theme.sh via emacsclient
;; a ogni cambio giorno/notte, e all'avvio per non restare sul tema sbagliato
;; se il segnale del portal è andato perso.
(defun my/darkman-sync (&optional mode)
  "Applica MODE (\"dark\" o \"light\"); se nil interroga darkman."
  (interactive)
  (let ((mode (or mode
                  (string-trim
                   (shell-command-to-string "darkman get 2>/dev/null")))))
    (when (member mode '("dark" "light"))
      (auto-dark--set-theme (intern mode)))))

(add-hook 'after-init-hook #'my/darkman-sync)

;; --------------------------------------------------
;; 2. Modeline
;; --------------------------------------------------

(use-package doom-modeline
  :demand t
  :config (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4))

(use-package nyan-mode
  :hook (after-init . nyan-mode))

;; --------------------------------------------------
;; 3. Completamento
;; --------------------------------------------------

(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t)
  (company-selection-wrap-around t)
  (company-dabbrev-downcase nil)
  (company-show-quick-access t)
  :config
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :config
  (when (display-graphic-p)
    (require 'all-the-icons)
    (setq company-box-icons-alist 'company-box-icons-all-the-icons)))

;; --------------------------------------------------
;; 4. Which-key
;; --------------------------------------------------

(use-package which-key
  :demand t
  :config (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom))

;; --------------------------------------------------
;; 5. Evidenziazione e finestre
;; --------------------------------------------------

(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

;; Regole uniche per i buffer di compilazione e i PDF.
(setq display-buffer-alist
      '(("\\*compilation\\*\\|\\*Compile-Log\\*"
         (display-buffer-below-selected)
         (window-height . 0.3)
         (window-parameters . ((no-other-window . nil))))
        ("\\.pdf\\'"
         (display-buffer-in-side-window)
         (side . right)
         (window-width . 0.35)
         (dedicated . t)
         (slot . 0))))

(global-set-key (kbd "C-x <up>")    #'windmove-up)
(global-set-key (kbd "C-x <down>")  #'windmove-down)
(global-set-key (kbd "C-x <left>")  #'windmove-left)
(global-set-key (kbd "C-x <right>") #'windmove-right)

(provide 'gui)
