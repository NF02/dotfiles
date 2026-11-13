;;; typst.el --- Typst configuration  -*- lexical-binding: t; -*-

;; --------------------------------------------------
;; 1. Funzioni di supporto
;; --------------------------------------------------

(defun my/typst--pdf-file ()
  "Percorso del PDF corrispondente al file .typ corrente, oppure nil."
  (when-let* ((file (buffer-file-name)))
    (concat (file-name-sans-extension file) ".pdf")))

(defun my/typst-compile-once ()
  "Compila il file .typ corrente in PDF."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Nessun file associato a questo buffer"))
  (let ((file (buffer-file-name))
        (pdf (my/typst--pdf-file)))
    (compile (format "typst compile %s %s"
                     (shell-quote-argument file)
                     (shell-quote-argument pdf)))))

(defun my/typst-watch ()
  "Avvia la compilazione continua del file .typ corrente."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Nessun file associato a questo buffer"))
  (let ((file (buffer-file-name))
        (pdf (my/typst--pdf-file)))
    (compile (format "typst watch %s %s"
                     (shell-quote-argument file)
                     (shell-quote-argument pdf)))
    (message "Typst watch avviato")))

(defun my/typst-view-pdf ()
  "Apre il PDF corrispondente in un'altra finestra."
  (interactive)
  (let ((pdf (my/typst--pdf-file)))
    (if (and pdf (file-exists-p pdf))
        (progn
          (find-file-other-window pdf)
          (when (fboundp 'pdf-view-fit-page-to-window)
            (pdf-view-fit-page-to-window)))
      (message "PDF non trovato: compila prima con C-c C-x"))))

;; --------------------------------------------------
;; 2. typst-ts-mode
;; --------------------------------------------------

(use-package typst-ts-mode
  :mode ("\\.typ\\'" . typst-ts-mode)
  :bind (:map typst-ts-mode-map
              ("C-c C-c" . my/typst-watch)
              ("C-c C-x" . my/typst-compile-once)
              ("C-c C-v" . my/typst-view-pdf))
  :hook (typst-ts-mode
         . (lambda ()
             (add-hook 'after-save-hook
                       #'my/revert-associated-pdf nil t))))

(provide 'typst)
