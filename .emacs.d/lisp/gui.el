;;; gui.el --- Interfaccia Grafica e Tema

;; 1. Font (Impostali subito per evitare ricalcoli dell'interfaccia)
(set-face-attribute 'default nil :font "OpenDyslexicM Nerd Font-11")
(add-to-list 'default-frame-alist '(font . "OpenDyslexicM Nerd Font-11"))

;; 2. Temi e Auto-Dark
(setq custom-safe-themes t)
(use-package doom-themes
  :ensure t)

(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-themes '((doom-dracula) (doom-gruvbox-light)))
  :init
  (auto-dark-mode 1))

;; 3. Modeline ed Estetica (Nyan Cat!)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4))

(use-package nyan-mode
  :ensure t
  :config (nyan-mode 1))

;; 4. Completamento (Company)
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t)
  (company-selection-wrap-around t)
  :config
  ;; Migliora la navigazione con le frecce/TAB
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

;; 5. Supporto Tasti (Which-key)
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom))

;; 6. Linea corrente (hl-line)
;; Più pulito: lo attiviamo per tutti i buffer di modifica
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

(provide 'gui)
