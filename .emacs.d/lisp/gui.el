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
