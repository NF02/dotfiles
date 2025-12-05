(require 'cl-lib) ; Assicura che la libreria per l'alist sia caricata

;; --- 1. CONFIGURAZIONE GLOBALE PER LA STABILITÀ E IL LAYOUT ---

;; 1.1. Silenziosità e Aggiornamento
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
;; Nasconde il buffer *Compile-Log* in caso di successo (mostrato solo su errore)
(setq compilation-window-height 0)

;; 1.2. Regola Layout per il Log (Log sotto l'Editor, a sinistra)
;; Quando c'è un errore, questa regola forza l'apertura del log SUDDIVIDENDO 
;; la finestra ATTIVA (che sarà l'Editor) orizzontalmente.
(setq display-buffer-alist
      (cl-acons
       "\\*compile-log\\*\\|\\*compilation\\*"
       (list
        'display-buffer-below-selected
        '(window-height . 0.3)
        'window)
       display-buffer-alist))


;; --- 2. FUNZIONI DI BASE TYPST (Definite in anticipo) ---

(defun typst-pdf-update-callback (buffer msg)
  "Richiamato dopo la compilazione Typst. Ricarica il PDF se è aperto."
  (when (string-match-p "finished" msg)
    (let* ((typst-file (buffer-file-name))
           (pdf-file (replace-regexp-in-string "\\.typ\\'" ".pdf" typst-file)))
      
      (dolist (buf (buffer-list))
        (when (and (equal (buffer-file-name buf) pdf-file)
                   (derived-mode-p 'pdf-view-mode))
          (with-current-buffer buf
            (sleep-for 0.1) ; Piccolo ritardo per stabilità
            (pdf-view-revert-buffer)))))))

(defun typst-compile ()
  "Compila il file Typst corrente e abilita l'aggiornamento automatico e silenzioso."
  (interactive)
  (let ((default-directory (file-name-directory (buffer-file-name))))
    
    (add-hook 'compilation-finish-hook 'typst-pdf-update-callback nil t)
    
    (compile (format "typst compile %s" (buffer-file-name)))
    
    (message "Avvio compilazione Typst... (C-c C-c)")))

(defun typst-view-pdf ()
  "Apre il PDF compilato in una FINESTRA ADIACENTE (a destra, full height)."
  (interactive)
  (let* ((typst-file (buffer-file-name))
         (pdf-file (replace-regexp-in-string "\\.typ\\'" ".pdf" typst-file)))
    
    (if (file-exists-p pdf-file)
        (progn
          (find-file-other-window pdf-file))
        (message "PDF non trovato: %s. Compilare prima con C-c C-c." pdf-file))))


;; --- 3. MAPPATURA TYPST-TS-MODE ---

(use-package typst-ts-mode
  :ensure t
  :mode "\\.typ\\'"
  :config
  ;; Mappa le funzioni definite sopra
  (add-hook 'typst-ts-mode-hook
            (lambda ()
              (define-key typst-ts-mode-map (kbd "C-c C-c") 'typst-compile)
              (define-key typst-ts-mode-map (kbd "C-c C-v") 'typst-view-pdf)))
)
