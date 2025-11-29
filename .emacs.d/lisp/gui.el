;; powerline
(require 'powerline)
(powerline-default-theme)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; which key
(require 'which-key)
(which-key-mode)
(which-key-setup-minibuffer)


;; h-ruler
;; Attiva hl-line-mode solo per i buffer di programmazione (prog-mode)
(add-hook 'prog-mode-hook #'hl-line-mode)

;; Attivalo solo per il testo (text-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

					; theme
;; Automatizza il caricamento sicuro dei temi
(setq custom-safe-themes t)  ; Considera tutti i temi come sicuri

(use-package auto-dark
  :ensure t ; Assicura che il pacchetto sia installato da MELPA
  :custom
  ;; 1. Definisci i tuoi temi scuro e chiaro preferiti
  (auto-dark-themes '( (doom-dracula)  ; Tema scuro
                       (doom-gruvbox-light) )) ; Tema chiaro
  
  ;; Opzioni avanzate (lasciare `nil` per l'auto-rilevamento)
  ;; (auto-dark-allow-osascript nil) ; Per macOS, usa il metodo nativo se Emacs lo supporta
  
  :init
  ;; Attiva la minor mode
  (auto-dark-mode)
  
  :config
  ;; Opzionale: puoi aggiungere hook personalizzati se vuoi che altre cose cambino
  ;; (add-hook 'auto-dark-dark-mode-hook (lambda () (message "Dark mode attivata!")))
  ;; (add-hook 'auto-dark-light-mode-hook (lambda () (message "Light mode attivata!")))
  )


;; Configurazione più semplice per emacsclient
(add-to-list 'default-frame-alist '(font . "OpenDyslexicM Nerd Font Mono-11"))
(when (display-graphic-p)
  ;; Configurazione ottimizzata
  (set-frame-font "OpenDyslexicM Nerd Font Mono-11" nil t)
  
  (custom-set-faces
   '(default ((t (:family "OpenDyslexicM Nerd Font Mono" :height 110))))
   '(fixed-pitch ((t (:family "OpenDyslexicM Nerd Font Mono" :height 110))))
   '(variable-pitch ((t (:family "OpenDyslexic Nerd Font Propo" :height 110)))))
  
  ;; Solo fallback essenziali
  (when (fboundp 'set-fontset-font)
    ;; Per emoji
    (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)
    ;; Per caratteri asiatici
    (set-fontset-font t 'chinese-gbk (font-spec :family "Noto Sans CJK SC") nil 'prepend)
    (set-fontset-font t 'japanese-jisx0208 (font-spec :family "Noto Sans CJK JP") nil 'prepend)
    (set-fontset-font t 'korean-ksc5601 (font-spec :family "Noto Sans CJK KR") nil 'prepend)
    ;; Fallback globale
    (set-fontset-font t nil (font-spec :family "DejaVu Sans") nil 'append))
  
  (message "✅ Font configurati!"))
