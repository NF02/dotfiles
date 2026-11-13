;;; latex-conf.el --- LaTeX/AUCTeX configuration  -*- lexical-binding: t; -*-

(declare-function TeX-revert-document-buffer "tex")

;; --------------------------------------------------
;; 1. CDLaTeX (prima di AUCTeX)
;; --------------------------------------------------

(use-package cdlatex
  :hook (LaTeX-mode . turn-on-cdlatex))

;; --------------------------------------------------
;; 2. AUCTeX
;; --------------------------------------------------

(use-package tex
  :ensure auctex
  :mode (("\\.tex\\'" . LaTeX-mode)
         ("\\.sty\\'" . LaTeX-mode)
         ("\\.cls\\'" . LaTeX-mode))
  :hook ((LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . TeX-fold-mode)
         (LaTeX-mode . flymake-mode))
  :config
  ;; Virgolette italiane
  (setq-default TeX-quote-language-alist
                '(("italian" "``" "''" nil)))
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-master nil
        TeX-save-query nil)
  ;; TeX-engine e TeX-command-default sono buffer-local: setq-default
  ;; per farli ereditare ai buffer .tex.
  (setq-default TeX-engine 'luatex)
  (setq-default TeX-command-default "LaTeXMk")
  ;; SyncTeX
  (setq TeX-source-correlate-mode t
        TeX-source-correlate-start-server t
        TeX-source-correlate-method 'synctex)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" "TeX-pdf-tools-sync-view"))))

;; --------------------------------------------------
;; 3. PDF Tools
;; --------------------------------------------------
;; Il server epdfinfo è già compilato da Nix: niente pdf-tools-install.

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :commands pdf-view-mode
  :custom
  (pdf-view-display-size 'fit-width)
  (pdf-view-use-scaling t)
  :config
  (when (boundp 'TeX-after-compilation-finished-functions)
    (add-hook 'TeX-after-compilation-finished-functions
              #'TeX-revert-document-buffer)))

(provide 'latex-conf)
