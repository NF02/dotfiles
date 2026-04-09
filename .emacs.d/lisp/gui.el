;; --------------------------------------------------
;; 1. Font
;; --------------------------------------------------

(set-face-attribute 'default nil :font "OpenDyslexicM Nerd Font-10")
(add-to-list 'default-frame-alist '(font . "OpenDyslexicM Nerd Font-10"))

;; --------------------------------------------------
;; 2. UI base
;; --------------------------------------------------

(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; --------------------------------------------------
;; 3. Temi + Auto dark
;; --------------------------------------------------

(setq custom-safe-themes t)

(use-package doom-themes
  :ensure t)

(use-package auto-dark
  :ensure t
  :custom
  ;; Definizione dei temi
  (auto-dark-themes '((doom-dracula) (doom-gruvbox-light)))
  ;; Su PGTK/Wayland 'dbus è il metodo più veloce, su macOS userà i framework Apple
  (auto-dark-detection-method 'dbus) 
  :init
  (auto-dark-mode 1)
  :config
  ;; SOLUZIONE PER EMACS SERVER & PGTK:
  ;; Forza il check del tema e il refresh dei font GTK ogni volta che 
  ;; viene creato un nuovo frame (emacsclient).
  (defun my/auto-dark-sync-pgtk (frame)
    (with-selected-frame frame
      (when (fboundp 'auto-dark--check)
        (auto-dark--check)
        ;; Refresh opzionale del font se noti glitch nel rendering PGTK
        (set-face-attribute 'default nil :font "OpenDyslexicM Nerd Font-10"))))

  (add-hook 'after-make-frame-functions #'my/auto-dark-sync-pgtk))
;; --------------------------------------------------
;; 4. Modeline
;; --------------------------------------------------

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4))

(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode 1))

;; --------------------------------------------------
;; 5. Completamento (Company)
;; --------------------------------------------------
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t)
  (company-selection-wrap-around t)
  ;; Evita che il completamento parta in contesti dove non serve (es. stringhe/commenti)
  (company-dabbrev-downcase nil)
  (company-show-numbers t) ; Utile per selezionare rapidamente con M-1, M-2...
  :config
  ;; Mappatura TAB: resta indentazione se non c'è il menu, conferma se c'è.
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  
  ;; Opzionale: usa C-n/C-p per navigare meglio nel popup invece delle frecce
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package company-box
  :ensure t
  :after (company all-the-icons)
  :hook (company-mode . company-box-mode)
  :config
  ;; Il valore corretto per usare le icone di all-the-icons è questo:
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

;; --------------------------------------------------
;; 6. Which-key
;; --------------------------------------------------

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom))

;; --------------------------------------------------
;; 7. Evidenziazione linea
;; --------------------------------------------------

(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

(provide 'gui)
