;;; lisp/typst-conf.el 
(require 'cl-lib)

;; --- 1. CONFIGURAZIONE LAYOUT (Specifico e pulito) ---

;; Invece di cl-acons globale, usiamo un approccio più leggibile
(setq display-buffer-alist
      (append '(("\\*compile-log\\*\\|\\*compilation\\*"
                 (display-buffer-below-selected)
                 (window-height . 0.3)))
              display-buffer-alist))

;; --- 2. FUNZIONI TYPST ---

(defun my/typst-pdf-update-callback (_buffer msg)
  "Ricarica il PDF se la compilazione finisce con successo."
  (when (string-match-p "finished" msg)
    (let* ((typst-file (buffer-file-name))
           (pdf-file (replace-regexp-in-string "\\.typ\\'" ".pdf" typst-file))
           (pdf-buf (find-buffer-visiting pdf-file)))
      (when (and pdf-buf (buffer-live-p pdf-buf))
        (with-current-buffer pdf-buf
          (run-at-time "0.1 sec" nil #'pdf-view-revert-buffer))))))

(defun my/typst-compile ()
  "Compila il file corrente."
  (interactive)
  (let ((default-directory (file-name-directory (buffer-file-name))))
    ;; Usiamo un hook locale per non sporcare le altre compilazioni
    (add-hook 'compilation-finish-hook #'my/typst-pdf-update-callback nil t)
    (compile (format "typst compile %s" (shell-quote-argument (buffer-file-name))))
    (message "Compilazione Typst avviata...")))

(defun my/typst-view-pdf ()
  "Apre il PDF a destra."
  (interactive)
  (let ((pdf-file (replace-regexp-in-string "\\.typ\\'" ".pdf" (buffer-file-name))))
    (if (file-exists-p pdf-file)
        (find-file-other-window pdf-file)
      (message "PDF non trovato. Compila prima con C-c C-c"))))

;; --- 3. IL PACCHETTO ---

(use-package typst-ts-mode
  :ensure t
  :mode "\\.typ\\'"
  :bind (:map typst-ts-mode-map
              ("C-c C-c" . my/typst-compile)
              ("C-c C-v" . my/typst-view-pdf))
  :config
  (setq auto-revert-verbose nil)
  (global-auto-revert-mode 1))

(provide 'typst)
