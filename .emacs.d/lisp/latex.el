;; --- PDF Tools ---
(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query) ; Installa/aggiorna senza chiedere ogni volta
  (setq-default pdf-view-display-size 'fit-width))

;; --- AUCTeX ---
(use-package auctex
  :ensure t
  :defer t
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t) ; Fondamentale per il parsing dei pacchetti
  (TeX-master nil)   ; Chiede quale sia il file master se non specificato
  :config
  ;; Integrazione con PDF Tools
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-mode t
        TeX-source-correlate-start-server t)
  
  ;; Aggiornamento PDF dopo compilazione
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

(setq TeX-source-correlate-mode t
      TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)  ;; Necessario per il "ritorno" dal PDF a Emacs

;; --- CDLatex & Math Preview ---
(use-package cdlatex
  :ensure t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (latex-mode . turn-on-cdlatex)))

(use-package latex-math-preview :ensure t)

;; --- Convertitori migliorati (Punti TeX standard) ---
(defun cm-to-pt (cm)
  "Convert CM to TeX points (1pt = 1/72.27 inch)."
  (interactive "nEnter CM: ")
  (let ((result (/ cm 0.035146)))
    (if (called-interactively-p 'interactive)
        (message "%.2f cm = %.4f pt (TeX)" cm result)
      result)))

(defun pt-to-cm (pt)
  "Convert TeX points to CM."
  (interactive "nEnter PT: ")
  (let ((result (* pt 0.035146)))
    (if (called-interactively-p 'interactive)
        (message "%.2f pt = %.4f cm" pt result)
      result)))

(provide 'latex)
