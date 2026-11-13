;;; dev.el --- Development configuration  -*- lexical-binding: t; -*-

;; --------------------------------------------------
;; Impostazioni globali di programmazione
;; --------------------------------------------------

(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Rimuove gli spazi in coda in tutti i modi di programmazione.
(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))

;; --------------------------------------------------
;; Octave
;; --------------------------------------------------

(use-package octave
  :ensure nil
  :mode ("\\.m\\'" . octave-mode)
  :hook (octave-mode . (lambda ()
                         (abbrev-mode 1)
                         (auto-fill-mode 1))))

;; --------------------------------------------------
;; Eat (terminale)
;; --------------------------------------------------

(use-package eat
  :hook (eshell-load . eat-eshell-mode)
  :bind ("C-c t" . eat)
  :custom
  (eat-enable-shell-prompt-annotation t)
  (eat-enable-kill-from-terminal nil))

;; --------------------------------------------------
;; Neotree
;; --------------------------------------------------

(use-package neotree
  :bind (([f5] . neotree-toggle)
         ("C-c r" . neotree-refresh))
  :config
  (setq neo-smart-open t
        neo-window-fixed-size nil))

;; --------------------------------------------------
;; COBOL
;; --------------------------------------------------

(use-package cobol-mode
  :mode ("\\.\\(cob\\|cbl\\|cpy\\)\\'" . cobol-mode))

;; --------------------------------------------------
;; Lisp (SLY)
;; --------------------------------------------------

(use-package sly
  :init
  (setq inferior-lisp-program "sbcl")
  :bind ("C-c s" . sly)
  :config
  (setq sly-lisp-implementations
        '((sbcl ("sbcl" "--dynamic-space-size" "5048")
                :coding-system utf-8-unix))))

;; --------------------------------------------------
;; C / C++
;; --------------------------------------------------

(use-package cc-mode
  :ensure nil
  :init
  (setq c-default-style "gnu")
  :bind (:map c-mode-map
              ("C-c C-c" . compile)
              ("C-c C-k" . kill-compilation)))

(setq gdb-many-windows t
      gdb-show-main t)

;; --------------------------------------------------
;; Nix
;; --------------------------------------------------

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;; --------------------------------------------------
;; Eglot (LSP)
;; --------------------------------------------------

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (csharp-mode . eglot-ensure)
         (LaTeX-mode . eglot-ensure)
         (php-mode . eglot-ensure)
         (typst-ts-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format-buffer))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0))
  :config
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd"
                           "--fallback-style=gnu"
                           "--header-insertion=never")))
  (add-to-list 'eglot-server-programs
               '(LaTeX-mode . ("texlab")))
  (add-to-list 'eglot-server-programs
               '(php-mode . ("phpactor" "language-server")))
  (when (executable-find "tinymist")
    (add-to-list 'eglot-server-programs
                 '(typst-ts-mode . ("tinymist")))))

(provide 'dev)
