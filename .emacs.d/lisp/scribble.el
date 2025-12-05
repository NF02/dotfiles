;; --- 1. CONFIGURAZIONE GLOBALE DI SILENZIOSITÀ E AGGIORNAMENTO ---
;; Nasconde il buffer di compilazione su successo e abilita l'aggiornamento automatico
(setq compilation-window-height 0)
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(require 'pdf-tools) ; Assicura che pdf-tools sia caricato per le funzioni a seguire


;; --- 2. FUNZIONE DI CALLBACK PER L'AGGIORNAMENTO AUTOMATICO ---
(defun scribble-pdf-update-callback (buffer msg)
  "Ricarica il PDF se è aperto dopo la compilazione Scribble."
  (when (string-match-p "finished" msg)
    (let* ((scrbl-file (buffer-file-name))
           (pdf-file (replace-regexp-in-string "\\.scrbl\\'" ".pdf" scrbl-file)))
      
      (dolist (buf (buffer-list))
        (when (and (equal (buffer-file-name buf) pdf-file)
                   (derived-mode-p 'pdf-view-mode))
          (with-current-buffer buf
            ;; 1. Aggiungi un piccolo ritardo (0.1 secondi) per dare tempo al file di essere riscritto.
            (sleep-for 0.1) 
            ;; 2. Forzare la ricarica del buffer PDF
            (pdf-view-revert-buffer)))))))

;; --- 3. FUNZIONI DI BASE SCRIBBL E RACKET ---
(defun scribble-compile-pdf ()
  "Esegue il comando Racket per compilare il file Scribble corrente in PDF."
  (interactive)
  (let* ((input-file (buffer-file-name))
         ;; Comando per generare il PDF
         (command (format "scribble --pdf %s" input-file)))
    
    ;; Aggiunge l'hook per l'aggiornamento (si rimuove dopo l'uso)
    (add-hook 'compilation-finish-hook 'scribble-pdf-update-callback nil t)
    
    ;; Esegue la compilazione usando la funzione standard 'compile' di Emacs
    (compile command)
    (message "Avvio compilazione Scribble... (Buffer nascosto su successo)")))

;; --- NUOVA CONFIGURAZIONE LAYOUT FINESTRE ---

(require 'cl-lib) ; Richiesto per la funzione cl-find-if (se non è già caricato)

(setq display-buffer-alist
      ;; Aggiunge una regola all'inizio della lista
      (cl-acons
       ;; 1. Regola: Quando un buffer ha un nome che inizia con *compilazione*
       "\\*compile-log\\*\\|\\*racket-output\\*\\|\\*racket-interaction\\*\\|\\*compilation\\*"
       
       ;; 2. Azione: Dividi la finestra, ma...
       (list
        'display-buffer-below-selected
        '(window-height . 0.3)  ; Dagli un'altezza di circa il 30% della finestra
        'window)
       
       ;; Mantieni il resto della lista
       display-buffer-alist))

;; --- MODIFICA ALLA FUNZIONE VIEW PDF PER GARANTIRE L'ORDINE ---
(defun scribble-view-pdf ()
  "Apre il PDF compilato in una finestra adiacente."
  (interactive)
  (let* ((scrbl-file (buffer-file-name))
         (pdf-file (replace-regexp-in-string "\\.scrbl\\'" ".pdf" scrbl-file)))
    
    (if (file-exists-p pdf-file)
        ;; Apre il PDF in una finestra adiacente (stesso frame)
        (find-file-other-window pdf-file)
      (message "PDF non trovato: %s. Compilare prima con C-c C-c." pdf-file))))

;; --- 4. MAPPATURA DEI TASTI (FLUSSO AUCTeX) ---
(use-package racket-mode
  :ensure t
  :mode ("\\.scrbl\\'" "\\.rkt\\'") 
  :config
  ;; Assicurati che pdf-tools sia configurato
  (pdf-tools-install)
  ;;(add-hook 'pdf-view-mode-hook 'pdf-view-fit-window-width)

  ;; Mappatura dei tasti
  (add-hook 'racket-mode-hook
            (lambda ()
              ;; C-c C-c: Compila, Aggiorna PDF e nasconde il log su successo
              (define-key racket-mode-map (kbd "C-c C-c") 'scribble-compile-pdf)
              ;; C-c C-v: Visualizza il PDF nella finestra accanto
              (define-key racket-mode-map (kbd "C-c C-v") 'scribble-view-pdf))))
