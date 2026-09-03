;;; -*- lexical-binding: t -*-
;; --------------------------------------------------
;; 1. Layout compilazioni
;; --------------------------------------------------
(setq display-buffer-alist
      (append '(("\\*compilation\\*"
                 (display-buffer-below-selected)
                 (window-parameters . ((no-other-window . nil)))
                 (window-height . 0.3)))
              display-buffer-alist))

;; --------------------------------------------------
;; 2. Funzioni Typst
;; --------------------------------------------------
(defun my/typst--pdf-file ()
  "Restituisce il percorso del PDF corrispondente al file .typ nel buffer corrente, oppure nil."
  (when-let ((file (buffer-file-name)))
    (concat (file-name-sans-extension file) ".pdf")))

(defun my/typst--pdf-buffer ()
  "Restituisce il buffer pdf-view associato al file .typ corrente, oppure nil."
  (when-let ((pdf (my/typst--pdf-file)))
    (find-buffer-visiting pdf)))

(defun my/typst-compile-once ()
  "Compila il file .typ una volta sola."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Nessun file associato a questo buffer"))
  (let ((cmd (format "typst compile %s"
                     (shell-quote-argument (buffer-file-name)))))
    (compile cmd)))

(defun my/typst-watch ()
  "Avvia compilazione continua (watch)."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Nessun file associato a questo buffer"))
  (let ((cmd (format "typst watch %s"
                     (shell-quote-argument (buffer-file-name)))))
    (compile cmd)
    (message "Typst watch avviato")))

(defun my/typst-view-pdf ()
  "Apre il PDF corrispondente in pdf-tools nell'altro window."
  (interactive)
  (let ((pdf (my/typst--pdf-file)))
    (if (and pdf (file-exists-p pdf))
        (progn
          (find-file-other-window pdf)
          (pdf-view-fit-page-to-window))
      (message "PDF non trovato — compila prima con C-c C-x"))))

(defun my/typst-revert-pdf ()
  "Ricarica il buffer PDF se aperto in pdf-view-mode."
  (when-let ((pdf-buf (my/typst--pdf-buffer)))
    (when (buffer-live-p pdf-buf)
      (with-current-buffer pdf-buf
        (when (derived-mode-p 'pdf-view-mode)
          (pdf-view-revert-buffer nil t))))))

;; --------------------------------------------------
;; 3. typst-ts-mode setup
;; --------------------------------------------------
(use-package typst-ts-mode
  :ensure t
  :mode "\\.typ\\'"
  :bind (:map typst-ts-mode-map
              ("C-c C-c" . my/typst-watch)
              ("C-c C-x" . my/typst-compile-once)
              ("C-c C-v" . my/typst-view-pdf))
  :hook (typst-ts-mode . (lambda ()
                           (add-hook 'after-save-hook
                                     #'my/typst-revert-pdf nil t)
                           (setq-local auto-revert-verbose nil)
                           (auto-revert-mode 1)))
  :config
  (setq auto-revert-verbose nil)
  (global-auto-revert-mode 1))

;; --------------------------------------------------
;; 4. Eglot LSP (opzionale)
;; --------------------------------------------------
(use-package eglot
  :ensure nil
  :config
  (when (executable-find "typst-lsp")
    (add-to-list 'eglot-server-programs
                 '(typst-ts-mode . ("typst-lsp" :stdio))))
  :hook ((typst-ts-mode . eglot-ensure)))

;; --------------------------------------------------
;; 5. pdf-tools (visualizzatore PDF)
;; --------------------------------------------------
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil))

(provide 'typst)
