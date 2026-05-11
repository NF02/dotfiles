;; --------------------------------------------------
;; 2. Funzioni LilyPond (Ricalibrate sui tuoi simboli)
;; --------------------------------------------------

(defun my/lilypond-compile ()
  "Avvia la compilazione asincrona di LilyPond."
  (interactive)
  (let ((cmd (format "lilypond %s"
                     (shell-quote-argument (buffer-file-name)))))
    (compile cmd)
    (message "Compilazione LilyPond avviata...")))

(defun my/lilypond-view-pdf ()
  "Apre il PDF prodotto a destra tramite PDF Tools."
  (interactive)
  (let* ((ly-file (buffer-file-name))
         (pdf-file (replace-regexp-in-string "\\.ly$" ".pdf" ly-file)))
    (if (file-exists-p pdf-file)
        (let ((pdf-buffer (find-file-noselect pdf-file)))
          (display-buffer-in-side-window 
           pdf-buffer 
           '((side . right) 
             (window-width . 0.5)
             (slot . 1))))
      (message "PDF non trovato — compila con C-c C-c"))))

;; --------------------------------------------------
;; 3. Setup lilypond-mode (Minuscolo, come da tuo help)
;; --------------------------------------------------

(use-package lilypond-mode
  :ensure nil
  :mode "\\.\\(ly\\|ily\\)$"
  :bind (:map lilypond-mode-map  ;; Nota il minuscolo
              ("C-c C-c" . my/lilypond-compile)
              ("C-c C-v" . my/lilypond-view-pdf)
              ("C-c C-s" . my/lilypond-view-pdf)) ;; Sovrascriviamo anche il tasto originale
  :hook (lilypond-mode . (lambda ()
                           ;; 1. Protezione anti-void: pulizia comandi
                           (when (boundp 'lilypond-command-alist)
                             (setq lilypond-command-alist (assoc-delete-all "View" lilypond-command-alist)))

                           ;; 2. Configurazione silenziosa revert
                           (setq-local revert-without-query '(".*\\.ly$" ".*\\.pdf$"))
                           
                           ;; 3. Refresh automatico post-salvataggio
                           (when (fboundp 'pdf-view-mode)
                             (add-hook 'after-save-hook 
                                       (lambda () 
                                         (let ((pdf-buf (get-file-buffer 
                                                         (replace-regexp-in-string "\\.ly$" ".pdf" (buffer-file-name)))))
                                           (when pdf-buf
                                             (with-current-buffer pdf-buf
                                               (revert-buffer t t t)))))
                                       nil t)))))

(provide 'lilypond)

