;; --------------------------------------------------
;; 1. Layout compilazioni
;; --------------------------------------------------
(setq display-buffer-alist
      (append '(("\\*compile-log\\*\\|\\*compilation\\*"
                 (display-buffer-below-selected)
                 (window-height . 0.3)))
              display-buffer-alist))

;; --------------------------------------------------
;; 2. Funzioni Typst
;; --------------------------------------------------

(defun my/typst-watch ()
  "Avvia compilazione continua 'typst watch'."
  (interactive)
  (let ((cmd (format "typst watch %s"
                     (shell-quote-argument (buffer-file-name)))))
    (compile cmd)
    (message "Typst watch avviato...")))

(defun my/typst-view-pdf ()
  "Apre il PDF a destra."
  (interactive)
  (let* ((typst-file (buffer-file-name))
         (pdf-file (replace-regexp-in-string \"\\.typ\\\\'\" \".pdf\" typst-file)))
    (if (file-exists-p pdf-file)
        (find-file-other-window pdf-file)
      (message \"PDF non trovato — compila con C-c C-c\"))))

;; --------------------------------------------------
;; 3. Setup Typst-mode
;; --------------------------------------------------
(use-package typst-ts-mode
  :ensure t
  :mode "\\.typ\\'"
  :bind (:map typst-ts-mode-map
              ("C-c C-c" . my/typst-watch)
              ("C-c C-v" . my/typst-view-pdf))
  :hook (typst-ts-mode . (lambda ()
                           (when (fboundp 'pdf-view-mode)
                             (add-hook 'after-save-hook #'revert-buffer nil t))))
  :config
  (setq auto-revert-verbose nil)
  (global-auto-revert-mode 1))
;; --------------------------------------------------
;; 4. Eglot Typst (LSP)
;; --------------------------------------------------
(use-package eglot
  :ensure nil
  :config
  (when (executable-find "typst-lsp")
    (add-to-list 'eglot-server-programs
                 '(typst-ts-mode . ("typst-lsp" :stdio))))
  :hook ((typst-ts-mode . eglot-ensure)))
(provide 'typst)
