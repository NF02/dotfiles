;; pdf tools
(require 'pdf-tools)
(use-package pdf-tools
  :init
  (pdf-tools-install))

;; AUCtex
(use-package auctex
  :ensure t
  :defer t)

;;; math preview
(use-package latex-math-preview)

;; cdlatex
(require 'cdlatex)
(add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook #'turn-on-cdlatex)   ; with Emacs latex mode

;;;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;;;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


;; pt convertor
;;; CM -> pt
(defun cm-to-pt (cm)
  "Convert CM to points (1cm=26.595744680851062pt)."
  (interactive "nEnter measurement in cm: ")
  (let ((result (/ cm 0.0376)))
    (if (called-interactively-p 'interactive)
        (message "%.4f cm = %.8f points" cm result)
      result)))

;;; pt -> CM
(defun pt-to-cm (pt)
  "Convert points to CM (26.595744680851062pt=1cm)."
  (interactive "nEnter measurement in pt: ")
  (let ((result (* pt 0.0376)))
    (if (called-interactively-p 'interactive)
        (message "%.8f points = %.4f cm" pt result)
      result)))

