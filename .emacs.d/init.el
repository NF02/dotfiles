;;; init.el --- Nicola's configuration  -*- lexical-binding: t; -*-

;; --------------------------------------------------
;; 1. Identità e percorsi
;; --------------------------------------------------

(setq user-full-name "Nicola Ferru"
      user-mail-address "ask.nfvblog@outlook.it")

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; --------------------------------------------------
;; 2. Pacchetti forniti da Nix
;; --------------------------------------------------
;; I pacchetti sono dichiarati in
;; ~/.config/home-manager/moduli/emacs-config.nix.
;; Non scaricare né installare nulla a runtime.

(setq use-package-always-ensure nil
      use-package-always-defer t
      use-package-enable-imenu-support t)

(require 'use-package)

;; --------------------------------------------------
;; 3. Prestazioni e comportamento globale
;; --------------------------------------------------

(setq read-process-output-max (* 1024 1024) ; LSP/processi più reattivi
      process-connection-type nil
      auto-revert-verbose nil
      use-short-answers t)

(setq-default indent-tabs-mode t
              tab-width 2)

(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

;; --------------------------------------------------
;; 4. Caricamento moduli (senza bloccare l'avvio)
;; --------------------------------------------------

(defun my/safe-load (module)
  "Carica MODULE solo se esiste, senza bloccare l'avvio."
  (condition-case err
      (require module)
    (error (message "Errore nel caricamento del modulo %s: %s"
                    module (error-message-string err)))))

(dolist (module '(gui dev web latex-conf typst presentazione org-conf rss git))
  (my/safe-load module))

;; --------------------------------------------------
;; 5. Minibuffer
;; --------------------------------------------------

(use-package vertico
  :demand t
  :config (vertico-mode))

(use-package marginalia
  :demand t
  :config (marginalia-mode))

;; --------------------------------------------------
;; 6. Ispell / flyspell
;; --------------------------------------------------

(when (executable-find "hunspell")
  (setq ispell-program-name "hunspell"
        ispell-dictionary "it_IT")
  (global-set-key (kbd "<f6>") #'flyspell-mode))

;; --------------------------------------------------
;; 7. Helper condivisi
;; --------------------------------------------------

(defun my/revert-associated-pdf ()
  "Ricarica il PDF associato al file corrente, se è già aperto."
  (when-let* ((file (buffer-file-name))
              (pdf (concat (file-name-sans-extension file) ".pdf"))
              (buffer (find-buffer-visiting pdf)))
    (with-current-buffer buffer
      (when (derived-mode-p 'pdf-view-mode)
        (revert-buffer t t t)))))

;; --------------------------------------------------
;; 8. Personalizzazioni salvate dalla UI
;; --------------------------------------------------

(load custom-file :no-error-if-not-found :no-message)

;; --------------------------------------------------
;; 9. Fine avvio
;; --------------------------------------------------

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)
            (garbage-collect)))

(provide 'init)
