;; --- Configurazione Sway/Wayland per Emacs PGTK ---

;; *** Shackle ***
(setq shackle-default-rule '(:frame t)
      shackle-display-buffer-frame-function 'sway-shackle-display-buffer-frame)

;; *** Modifiche specifiche per Sway/PGTK ***

(sway-socket-tracker-mode) ; Essenziale per l'interazione con l'IPC di Sway. (Mantenuto)
(sway-undertaker-mode)     ; Gestisce i buffer dedicati (Mantenuto)

;; *** Funzione my/toggle-fullscreen-dwim ***
(defun my/toggle-fullscreen-dwim ()
  "A unified fullscreen command for Sway and Emacs PGTK.
   Disambiguates between Sway's fullscreen and Emacs' internal maximization."
  (interactive)
  (if (window-system) ; Verifica se Emacs è in un ambiente grafico (sempre vero per PGTK)
      (progn
        ;; La funzione PGTK per lo stato massimizzato è `frame-maximized-p`
        (if (frame-maximized-p)
            (progn
              ;; Se Emacs è massimizzato internamente, lo ripristina
              (toggle-maximize-buffer)
              ;; E poi usa Sway per togliere il fullscreen (se applicabile)
              (my/sway-toggle-fullscreen))
          ;; Altrimenti, prima attiva il fullscreen di Sway
          (my/sway-toggle-fullscreen)
          ;; E poi massimizza internamente Emacs
          (toggle-maximize-buffer)))
    ;; Se non è grafico (es. terminale), fai solo il toggle di Sway
    (my/sway-toggle-fullscreen)))
