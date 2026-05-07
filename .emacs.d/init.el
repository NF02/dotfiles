;;; init.el --- Nicola's Clean Configuration

;; 1. Ottimizzazioni GC
(setq gc-cons-threshold (* 50 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1024 1024))))

;; 2. Definizioni Percorsi (Fondamentale farlo PRIMA dei caricamenti)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 3. Gestione Pacchetti
(require 'package)
(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
                         ("elpa"   . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; 4. Caricamento Moduli (Con protezione contro i crash)
(defun my/safe-load (module)
  "Carica un modulo solo se esiste, senza bloccare l'avvio."
  (condition-case err
      (require module)
    (error (message "Errore nel caricamento del modulo %s: %s" module (error-message-string err)))))

;; Carica le credenziali (percorso corretto relativo a .emacs.d/lisp/)
(let ((secrets (expand-file-name "lisp/credential.el" user-emacs-directory)))
  (if (file-exists-p secrets)
      (load secrets)
    (message "Credential file non trovato")))

;; Carica i tuoi file in lisp/
(my/safe-load 'gui)
(my/safe-load 'dev)
(my/safe-load 'web)
(my/safe-load 'latex-conf)
(my/safe-load 'typst)
(my/safe-load 'org-conf)
(my/safe-load 'rss)
(my/safe-load 'git)
(my/safe-load 'llm)
(my/safe-load 'lilypond)

;; 5. Modernizzazione Minibuffer (Vertico)
(use-package vertico
  :init (vertico-mode))

(use-package marginalia
  :ensure t
  :init (marginalia-mode)) ; Aggiunge descrizioni ai comandi M-x

;; 6. Fine: Carica le personalizzazioni salvate dalla UI
(when (file-exists-p custom-file)
  (load custom-file))

;; 7. Ispell
(use-package ispell
  :if (executable-find "hunspell")
  :config
  (setq ispell-program-name "hunspell")
  :bind ([f6] . flyspell-mode))
