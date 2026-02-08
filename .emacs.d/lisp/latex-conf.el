;;; latex-config.el --- Modern LaTeX setup for Emacs 30

;; ─────────────────── AUCTeX Setup ───────────────────
(use-package tex
  :ensure auctex
  :hook ((LaTeX-mode . eglot-ensure)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . turn-on-cdlatex)
         (LaTeX-mode . company-mode)
         (LaTeX-mode . TeX-fold-mode))
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-master nil
        TeX-save-query nil
        TeX-command-default "LatexMk")

  ;; SyncTeX (source ↔ PDF)
  (setq TeX-source-correlate-start-server t
        TeX-source-correlate-method 'synctex)

  ;; Auto-reload PDF after compilation
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

;; ─────────────────── PDF viewer selection ───────────────────
;; IMPORTANT:
;; Do NOT touch TeX-view-program-list.
;; AUCTeX + pdf-tools already define "PDF Tools" correctly.
(with-eval-after-load 'tex
  (setq TeX-view-program-selection
        '((output-pdf "PDF Tools"))))

;; ────────────────── Eglot + TexLab LSP ─────────────────
(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs
               '(LaTeX-mode . ("texlab"))))

;; ─────────────────── PDF Tools ───────────────────
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq pdf-view-display-size 'fit-width
        pdf-view-use-scaling t)
  (add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode))

;; ───────────────── RefTeX ─────────────────
(use-package reftex
  :ensure nil
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t))

;; ───────────────── Display PDF in Side Window ─────────────────
(add-to-list 'display-buffer-alist
             '("\\.pdf\\'"
               (display-buffer-in-side-window)
               (side . right)
               (window-width . 0.35)
               (slot . 0)))

;; ───────────────── LaTeX Math Preview ─────────────────

(use-package latex-math-preview
  :ensure t
  :hook ((LaTeX-mode . latex-math-preview-mode))
  :config
  ;; Aggiorna automaticamente quando modifichi la formula
  (setq latex-math-preview-auto-update t
        ;; Usa una scala decente su schermi HiDPI
        latex-math-preview-scale 1.5
        ;; Usa l'engine coerente con latexmk
        latex-math-preview-latex-engine 'lualatex))

;; Keybindings utili
(with-eval-after-load 'latex-math-preview
  ;; Preview formula alla posizione del cursore
  (define-key LaTeX-mode-map (kbd "C-c p m")
              #'latex-math-preview-at-point)

  ;; Pulisce tutte le preview nel buffer
  (define-key LaTeX-mode-map (kbd "C-c p c")
              #'latex-math-preview-clear-buffer))

(provide 'latex-config)
;;; latex-config.el ends here
