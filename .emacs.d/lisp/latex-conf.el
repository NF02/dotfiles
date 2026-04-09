;; --------------------------------------------------
;; 1. CDLaTeX (prima di AUCTeX)
;; --------------------------------------------------

(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex))

;; Virgolette italiane
(setq-default TeX-quote-language-alist
              '(("italian" "``" "''" nil)))

;; --------------------------------------------------
;; 2. AUCTeX
;; --------------------------------------------------

(use-package tex
  :ensure auctex
  :mode (("\\.tex\\'" . LaTeX-mode)
         ("\\.sty\\'" . LaTeX-mode)
         ("\\.cls\\'" . LaTeX-mode))
  :hook ((LaTeX-mode . eglot-ensure)
         (LaTeX-mode . turn-on-reftex)
         (LaTeX-mode . TeX-fold-mode))
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-master nil
        TeX-engine 'default
        TeX-command-default "LatexMk"
        TeX-save-query nil)

  ;; SyncTeX
  (setq TeX-source-correlate-mode t
        TeX-source-correlate-start-server t
        TeX-source-correlate-method 'synctex)

  ;; Viewer PDF Tools
  (with-eval-after-load 'tex
    (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
          TeX-view-program-list '(("PDF Tools" "TeX-pdf-tools-sync-view")))))

;; --------------------------------------------------
;; 3. PDF Tools
;; --------------------------------------------------

(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq pdf-view-display-size 'fit-width)
  (add-hook 'pdf-view-mode-hook #'auto-revert-mode)
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

;; --------------------------------------------------
;; 4. Finestre PDF
;; --------------------------------------------------

(setq display-buffer-alist
      '(("\\.pdf\\'"
         (display-buffer-in-side-window)
         (side . right)
         (window-width . 0.35)
         (dedicated . t)
         (slot . 0))))

;; --------------------------------------------------
;; 5. Navigazione finestre
;; --------------------------------------------------

(global-set-key (kbd "C-x <up>")    #'windmove-up)
(global-set-key (kbd "C-x <down>")  #'windmove-down)
(global-set-key (kbd "C-x <left>")  #'windmove-left)
(global-set-key (kbd "C-x <right>") #'windmove-right)

(provide 'latex-conf)
