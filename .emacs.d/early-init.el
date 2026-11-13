;;; early-init.el --- Avvio rapido e UI iniziale  -*- lexical-binding: t; -*-

;; GC molto alta durante l'avvio: viene ripristinata a fine init.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Non ricompattare le cache dei font a ogni avvio.
(setq inhibit-compacting-font-caches t)

;; Workaround: typst-ts-mode-autoloads usa `define-compilation-mode'
;; prima che compile.el sia caricato, causando un errore all'avvio.
(require 'compile)

;; Niente schermata di benvenuto.
(setq inhibit-startup-screen t)

;; UI impostata prima della creazione del frame: niente flicker.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "OpenDyslexicM Nerd Font-10"))
(add-to-list 'default-frame-alist '(alpha-background . 95))

(provide 'early-init)
