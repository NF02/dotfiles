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
  (auto-dark-themes '((doom-dracula) (doom-gruvbox-light)))
  :init
  (auto-dark-mode 1)
  :config
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (select-frame frame)
              (auto-dark--check))))

(setq auto-dark-allow-multi-theme t) 
(add-hook 'auto-dark-dark-mode-hook (lambda () (message "Passaggio a modalità scura...")))
(add-hook 'auto-dark-light-mode-hook (lambda () (message "Passaggio a modalità chiara...")))


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

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t)
  (company-selection-wrap-around t)
  :config
  ;; TAB resta indent, usa solo in popup
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

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
