(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; -----------------------------------------------------------------
;;  Octave (Built-in)
;; -----------------------------------------------------------------
(use-package octave
  :mode ("\\.m\\'" . octave-mode)
  :config
  (add-hook 'octave-mode-hook
            (lambda ()
              (abbrev-mode 1)
              (auto-fill-mode 1)
              (display-line-numbers-mode 1)
              (when (display-graphic-p)
                (font-lock-mode 1)))))

;; -----------------------------------------------------------------
;;  Eat (Terminal Emulator)
;; ----------------------------------------------------------------
(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode)
  :custom
  (eat-shell-prompt-annotation t)
  (eat-enable-kill-from-terminal nil)
  (eat-sixel-enabled t)
  :config
  (when (fboundp 'sixel-display-mode)
    (sixel-display-mode 1)))

;; -----------------------------------------------------------------
;;  Neotree
;; -----------------------------------------------------------------
(use-package neotree
  :ensure t
  :bind (([f5] . neotree-toggle)
         ("C-c r" . neotree-refresh)))

;; -----------------------------------------------------------------
;;  GNU COBOL
;; -----------------------------------------------------------------
(use-package cobol-mode
  :ensure t
  :mode ("\\.\\(cob\\|cbl\\|cpy\\)\\'" . cobol-mode))

;; -----------------------------------------------------------------
;;  SLIME (Superior Lisp Interaction Mode)
;; -----------------------------------------------------------------
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))
(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  :bind ("C-c s" . sly)
  :config
  ;; Integrazione Wayland/Sway con 5GB di RAM
  (setq sly-lisp-implementations
        `((sbcl ("sbcl" "--dynamic-space-size" "5048")
                :env (,(concat "WAYLAND_DISPLAY=" (getenv "WAYLAND_DISPLAY"))
      "GDK_BACKEND=wayland")))))

;; -----------------------------------------------------------------
;;  Processing
;; -----------------------------------------------------------------
(use-package processing-mode
  :ensure t
  :custom
  (processing-location "~/.local/processing-4.3/processing-java")
  (processing-application-dir "~/.local/processing-4.3/processing")
  (processing-sketchbook-dir "~/Documenti/processing"))

;; -----------------------------------------------------------------
;;  Docker
;; -----------------------------------------------------------------
(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile\\'")

(use-package docker-cli
  :ensure t
  :custom
  (dockerfile-mode-command "docker"))

;; -----------------------------------------------------------------
;;  C mode
;; -----------------------------------------------------------------
(use-package cc-mode
  :ensure nil
  :config
  ;; 1. Stile GNU Puro
  (setq c-default-style "gnu")
  
  ;; 2. Numeri di riga (fondamentali per il debugging)
  (add-hook 'c-mode-hook #'display-line-numbers-mode)

  ;; 3. Cleanup automatico: rimuove spazi bianchi a fine riga al salvataggio
  (add-hook 'c-mode-hook (lambda () (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))

  :bind (:map c-mode-map
              ("C-c C-c" . compile)          ; Lancia 'make' o il comando di compilazione
              ("C-c C-k" . kill-compilation) ; Ferma la compilazione
              ("<f1>" . manual-entry)))      ; Apre la pagina MAN del cursore

;; --- Integrazione GDB (Il Debugger Unix) ---
(setq
 ;; gdb-many-windows: apre il layout IDE con stack, variabili e sorgente
 gdb-many-windows t
 ;; gdb-show-main: mostra subito il codice sorgente all'avvio
 gdb-show-main t)

;; -----------------------------------------------------------------
;;  eglot (minimal lsp)
;; -----------------------------------------------------------------
(use-package eglot
  :ensure nil 
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (js-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format-buffer)
              ("M-." . xref-find-definitions))
  :config
  (add-to-list 'eglot-server-programs
               '(octave-mode . ("octave-lsp"))
	       '(c-mode . ("clangd" "--fallback-style=gnu"))))

(provide 'dev)
