;;; dev.el --- Development configuration  -*- lexical-binding: t; -*-

;; --------------------------------------------------
;; Global settings
;; --------------------------------------------------

;; Usa il carattere TAB reale, non gli spazi
(setq-default indent-tabs-mode t)

;; Definisce l'ampiezza del carattere TAB (es. 2 colonne)
(setq-default tab-width 2)

;; Numeri di riga relativi (ottimo per i movimenti in Evil mode)
(setq display-line-numbers-type 'relative)


;; --------------------------------------------------
;; Octave
;; --------------------------------------------------

(use-package octave
  :mode ("\\.m\\'" . octave-mode)
  :config
  (setq octave-block-offset 2)
  (add-hook 'octave-mode-hook
            (lambda ()
              (abbrev-mode 1)
              (auto-fill-mode 1)
              (display-line-numbers-mode 1))))

;; --------------------------------------------------
;; Eat (Terminal Emulator)
;; --------------------------------------------------

(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode)
  :bind (("C-c t" . eat))
  :custom
  (eat-shell-prompt-annotation t)
  (eat-enable-kill-from-terminal nil)
  (eat-sixel-enabled t)
  :config
  (when (fboundp 'sixel-display-mode)
    (sixel-display-mode 1)))

;; --------------------------------------------------
;; Neotree
;; --------------------------------------------------

(use-package neotree
  :ensure t
  :bind (([f5] . neotree-toggle)
         ("C-c r" . neotree-refresh))
  :config
  (setq neo-smart-open t
        neo-window-fixed-size nil))

;; --------------------------------------------------
;; COBOL
;; --------------------------------------------------

(use-package cobol-mode
  :ensure t
  :mode ("\\.\\(cob\\|cbl\\|cpy\\)\\'" . cobol-mode))

;; --------------------------------------------------
;; Lisp (SLY)
;; --------------------------------------------------

(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  :bind ("C-c s" . sly)
  :config
  (setq sly-lisp-implementations
        (when (getenv "WAYLAND_DISPLAY")
          `((sbcl ("sbcl" "--dynamic-space-size" "5048")
                  :env (,(concat "WAYLAND_DISPLAY=" (getenv "WAYLAND_DISPLAY"))
                        "GDK_BACKEND=wayland"))))))

;; --------------------------------------------------
;; Processing
;; --------------------------------------------------

(use-package processing-mode
  :ensure t
  :custom
  (processing-location (expand-file-name "~/.local/processing-4.3/processing-java"))
  (processing-application-dir (expand-file-name "~/.local/processing-4.3/processing"))
  (processing-sketchbook-dir (expand-file-name "~/Documenti/processing")))

;; --------------------------------------------------
;; C / C++
;; --------------------------------------------------

(use-package cc-mode
  :ensure nil
  :config
  (setq c-default-style "gnu")
  (add-hook 'c-mode-hook #'display-line-numbers-mode)
  (add-hook 'c-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))
  :bind (:map c-mode-map
              ("C-c C-c" . compile)
              ("C-c C-k" . kill-compilation)
              ("<f1>" . manual-entry)))

(setq gdb-many-windows t
      gdb-show-main t)

;; --------------------------------------------------
;; Eglot (LSP)
;; --------------------------------------------------

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (csharp-mode . eglot-ensure)
         (LaTeX-mode . eglot-ensure)
         (php-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format-buffer)
              ("M-." . xref-find-definitions))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0))
  (setq eglot-server-programs
        (append eglot-server-programs
                '((c-mode . ("clangd"
                             "--fallback-style=gnu"
                             "--query-driver=/usr/bin/clang"
                             "--extra-arg=-std=c23"
                             "--header-insertion=never"))
                  (LaTeX-mode . ("texlab"))
                  (php-mode . ("phpactor" "language-server"))))))

(provide 'dev)
