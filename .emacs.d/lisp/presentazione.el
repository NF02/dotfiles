;;; presentazione.el --- Presentazioni Org con org-tree-slide  -*- lexical-binding: t; -*-

;;; Commentary:
;; Tutta la logica di presentazione:
;; - scala globale della slide, per non far mai uscire il contenuto
;;   dal frame visivo (in larghezza e in altezza);
;; - ridimensionamento delle tabelle che non stanno in larghezza.
;;
;; La scala globale agisce sulla faccia `default': così ogni elemento
;; della slide (testo, titoli, codice, tabelle) si riduce in modo
;; uniforme e nulla resta disallineato.

;;; Code:

(require 'face-remap)
(require 'seq)

;; Variabili esterne usate da visual-fill-column
(defvar visual-fill-column-width)

(declare-function org-string-width "org-macs"
                  (string &optional pixels default-face invisibility-spec))
(declare-function org-tree-slide-mode "org-tree-slide" (&optional arg))
(defvar org-tree-slide-mode)
(defvar org-tree-slide--header-overlay)

;; --------------------------------------------------
;; 1. Configurazione
;; --------------------------------------------------

(defgroup my/org-presentation nil
  "Presentazioni Org con org-tree-slide."
  :group 'org)

(defcustom my/org-presentation-text-scale 1.5
  "Ingrandimento di partenza del testo in presentazione."
  :type 'number
  :group 'my/org-presentation)

(defcustom my/org-presentation-min-scale 0.25
  "Scala minima della slide.
Sotto questo valore il testo diventerebbe troppo piccolo: meglio
lasciare che il contenuto scorra piuttosto che renderlo illeggibile."
  :type 'number
  :group 'my/org-presentation)

(defcustom my/org-presentation-margin 8
  "Margine verticale di sicurezza, in pixel."
  :type 'integer
  :group 'my/org-presentation)

;; Scala globale attualmente applicata alla slide (nil = non attiva).
(defvar-local my/org-presentation-current-scale nil)

;; Cookie del remap della faccia `default' usato per la scala globale.
(defvar-local my/org-presentation-remap nil)

;; Overlay usati per scalare le singole tabelle.
(defvar-local my/org-table-overlays nil)

;; --------------------------------------------------
;; 2. Scala globale della slide
;; --------------------------------------------------

(defun my/org-presentation--text-scale ()
  "Fattore di scala effettivo del testo nella slide.
Include la scala globale e l'eventuale `text-scale-mode'."
  (* (or my/org-presentation-current-scale
         my/org-presentation-text-scale)
     (if (bound-and-true-p text-scale-mode)
         (expt text-scale-mode-step text-scale-mode-amount)
       1.0)))

(defun my/org-presentation--apply-scale (scale)
  "Applica SCALE alla faccia `default' della slide."
  (when my/org-presentation-remap
    (face-remap-remove-relative my/org-presentation-remap))
  (setq my/org-presentation-current-scale scale
        my/org-presentation-remap
        (face-remap-add-relative 'default :height scale))
  (when (fboundp 'my/org-latex-preview-refresh-scaling)
    (my/org-latex-preview-refresh-scaling)))

(defun my/org-presentation--reset-scale ()
  "Riporta la slide alla scala di partenza."
  (my/org-presentation--apply-scale my/org-presentation-text-scale))

(defun my/org-presentation--prefix-pixels (prefix)
  "Larghezza in pixel del prefisso di riga PREFIX."
  (if (stringp prefix)
      (round (* (my/org-presentation--text-scale)
                (org-string-width prefix t)))
    0))

(defun my/org-presentation--header-pixels ()
  "Altezza in pixel occupata dall'intestazione di org-tree-slide.
La prima riga dell'header sostituisce quella del titolo, già
inclusa nella misura del buffer, quindi non va contata due volte."
  (let ((overlay (bound-and-true-p org-tree-slide--header-overlay)))
    (when (overlayp overlay)
      (let ((display (overlay-get overlay 'display)))
        (when (stringp display)
          (let ((lines (1+ (seq-count (lambda (c) (eq c ?\n)) display))))
            (* (max 0 (1- lines))
               (or (window-font-height
                    nil 'org-tree-slide-header-overlay-face)
                   (window-font-height)))))))))

(defun my/org-presentation--content-size (area-width)
  "Restituisce (LARGHEZZA . ALTEZZA) del contenuto della slide.
Il testo viene misurato come appare con wrapping ad AREA-WIDTH."
  (let ((window (get-buffer-window (current-buffer) t)))
    (if (and window (eq (window-buffer window) (current-buffer)))
        (with-selected-window window
          (window-text-pixel-size nil (point-min) (point-max) area-width))
      (with-selected-window (or (get-buffer-window (current-buffer))
                                (selected-window))
        (buffer-text-pixel-size (current-buffer) nil area-width)))))

;; --------------------------------------------------
;; 3. Tabelle
;; --------------------------------------------------

(defun my/org-presentation--line-pixels (beg end)
  "Larghezza in pixel della riga BEG..END come viene visualizzata.
I caratteri invisibili (per esempio i marcatori di enfasi nascosti)
non contano: altrimenti la tabella risulterebbe più larga del vero."
  (let* ((prefix (get-text-property beg 'line-prefix))
         (text (buffer-substring beg end))
         (full (if (stringp prefix) (concat prefix text) text)))
    (round (* (my/org-presentation--text-scale)
              (org-string-width full t)))))

(defun my/org-presentation--table-regions ()
  "Elenco delle tabelle nella restrizione corrente, come (BEG . END)."
  (save-excursion
    (goto-char (point-min))
    (let (regions start last-end)
      (while (re-search-forward "^[ \t]*|" nil t)
        (let ((beg (line-beginning-position))
              (end (line-end-position)))
          (unless (and last-end (= beg (1+ last-end)))
            (when start (push (cons start last-end) regions))
            (setq start beg))
          (setq last-end end)))
      (when start (push (cons start last-end) regions))
      (nreverse regions))))

(defun my/org-presentation--region-max-pixels (beg end)
  "Larghezza massima in pixel delle righe di tabella tra BEG ed END."
  (save-excursion
    (goto-char beg)
    (let ((max-width 0))
      (while (< (point) end)
        (setq max-width
              (max max-width
                   (my/org-presentation--line-pixels
                    (line-beginning-position)
                    (line-end-position))))
        (forward-line 1))
      max-width)))

(defun my/org-presentation--text-area-pixels ()
  "Larghezza in pixel dell'area di testo della finestra selezionata.
`window-body-width' esclude già margini, fringe e scrollbar."
  (window-body-width nil t))

(defun my/org-presentation-fit-tables ()
  "Ridimensiona solo le tabelle che non stanno in larghezza.
La scala è applicata con un overlay, così tutte le facce presenti
nella tabella (verbatim, grassetto, caratteri speciali) si riducono
in modo uniforme e le colonne restano allineate.
Va chiamata con la slide già ristretta."
  (when (and (derived-mode-p 'org-mode)
             (bound-and-true-p org-tree-slide-mode))
    ;; Ricrea tutto a partire dalla scala normale, così i ricalcoli
    ;; successivi non accumulano riduzioni.
    (mapc #'delete-overlay my/org-table-overlays)
    (setq my/org-table-overlays nil)
    (let ((area (max 1 (my/org-presentation--text-area-pixels))))
      (dolist (region (my/org-presentation--table-regions))
        (let* ((table-width (my/org-presentation--region-max-pixels
                             (car region) (cdr region)))
               (scale (if (> table-width area)
                          ;; Solo le tabelle che sforano vengono
                          ;; ridotte; le altre restano come sono.
                          (max 0.35 (* 0.98 (/ (float area) table-width)))
                        1.0)))
          (unless (>= scale 0.999)
            (let ((overlay (make-overlay (car region) (cdr region))))
              (overlay-put overlay 'face (list :height scale))
              (overlay-put overlay 'evaporate t)
              (push overlay my/org-table-overlays))))))))

;; --------------------------------------------------
;; 4. Larghezza dei token non spezzabili
;; --------------------------------------------------

(defun my/org-presentation--region-containing-p (pos regions)
  "Non-nil se POS cade dentro una delle REGIONS."
  (seq-some (lambda (region)
              (and (>= pos (car region)) (<= pos (cdr region))))
            regions))

(defun my/org-presentation--max-unbreakable-pixels (table-regions)
  "Larghezza massima di un token che non può andare a capo.
Le righe delle tabelle sono escluse perché gestite a parte.
Il testo normale, andando a capo, non ha bisogno di essere ridotto:
conta solo la parola più lunga che non può essere spezzata."
  (let ((max-width 0))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let ((beg (line-beginning-position))
              (end (line-end-position)))
          (unless (my/org-presentation--region-containing-p
                   beg table-regions)
            (let* ((prefix (or (get-text-property beg 'line-prefix)
                               (get-text-property beg 'wrap-prefix)))
                   (extra (my/org-presentation--prefix-pixels prefix))
                   (scale (my/org-presentation--text-scale)))
              (dolist (token (split-string
                              (buffer-substring beg end)
                              "[ \t]+" t))
                (let ((width (+ extra
                                (round (* scale
                                          (org-string-width token t))))))
                  (when (> width max-width)
                    (setq max-width width)))))))
        (forward-line 1)))
    max-width))

;; --------------------------------------------------
;; 5. Adattamento complessivo
;; --------------------------------------------------

(defun my/org-presentation-fit-slide ()
  "Adatta l'intera slide allo spazio visibile della finestra.
Riduce uniformemente il testo (faccia `default') finché contenuto,
intestazione e tabelle non stanno sia in larghezza sia in altezza.
Le tabelle troppo larghe vengono ridotte a parte con un overlay,
così non costringono a rimpicciolire tutta la slide.
Va chiamata con la slide già ristretta."
  (when (and (derived-mode-p 'org-mode)
             (bound-and-true-p org-tree-slide-mode))
    (my/org-presentation--reset-scale)
    (my/org-presentation-fit-tables)
    (let* ((area-width (max 1 (my/org-presentation--text-area-pixels)))
           (scale my/org-presentation-text-scale))
      (catch 'done
        (dotimes (_ 5)
          (let* ((table-regions (my/org-presentation--table-regions))
                 (max-token
                  (my/org-presentation--max-unbreakable-pixels table-regions))
                 (area-height
                  (max 1 (- (window-body-height nil t)
                            (or (my/org-presentation--header-pixels) 0)
                            my/org-presentation-margin)))
                 (size (my/org-presentation--content-size area-width))
                 (height (cdr size))
                 (width-factor (if (> max-token area-width)
                                   (/ (float area-width) max-token)
                                 1.0))
                 (height-factor (if (> height area-height)
                                    (/ (float area-height) height)
                                  1.0))
                 (factor (min width-factor height-factor)))
            (if (>= factor 0.999)
                (throw 'done nil)
              (setq scale (max my/org-presentation-min-scale
                               (* scale factor)))
              (my/org-presentation--apply-scale scale))))))))

(defun my/org-presentation-refit (frame)
  "Ricalcola l'adattamento della slide quando FRAME cambia dimensione."
  (dolist (window (window-list frame 'nomini))
    (with-current-buffer (window-buffer window)
      (when (and (bound-and-true-p org-tree-slide-mode)
                 (derived-mode-p 'org-mode))
        (with-selected-window window
          (my/org-presentation-fit-slide))))))

(add-hook 'window-size-change-functions #'my/org-presentation-refit)

;; --------------------------------------------------
;; 6. Avvio e arresto della presentazione
;; --------------------------------------------------

(defun my/org-tree-slide-start ()
  "Attiva la modalità presentazione."
  (setq visual-fill-column-width 110)
  (set-frame-parameter nil 'internal-border-width 40)
  (setq-local mode-line-format nil)
  ;; Il remap va fatto prima di attivare visual-fill-column, che calcola
  ;; i margini in base alla dimensione effettiva del carattere.
  (my/org-presentation--reset-scale)
  (visual-fill-column-mode 1)
  (my/org-presentation-fit-slide)
  (force-mode-line-update))

(defun my/org-tree-slide-stop ()
  "Disattiva la modalità presentazione."
  (mapc #'delete-overlay my/org-table-overlays)
  (setq my/org-table-overlays nil)
  (when my/org-presentation-remap
    (face-remap-remove-relative my/org-presentation-remap)
    (setq my/org-presentation-remap nil
          my/org-presentation-current-scale nil))
  (when (fboundp 'my/org-latex-preview-refresh-scaling)
    (my/org-latex-preview-refresh-scaling))
  (visual-fill-column-mode -1)
  (set-frame-parameter nil 'internal-border-width 0)
  (kill-local-variable 'mode-line-format)
  (force-mode-line-update))

(defun my/org-tree-slide-toggle ()
  "Adatta il frame allo stato di org-tree-slide."
  (if org-tree-slide-mode
      (my/org-tree-slide-start)
    (my/org-tree-slide-stop)))

;; --------------------------------------------------
;; 7. Pacchetti
;; --------------------------------------------------

(use-package visual-fill-column
  :commands visual-fill-column-mode
  :custom
  (visual-fill-column-width 100)
  (visual-fill-column-center-text t))

(use-package org-tree-slide
  :commands (org-tree-slide-mode
             org-tree-slide-move-next-tree
             org-tree-slide-move-previous-tree)
  :bind (:map org-tree-slide-mode-map
              ("C-q" . org-tree-slide-mode))
  :hook (org-tree-slide-mode . my/org-tree-slide-toggle)
  :custom
  (org-tree-slide-header t)
  (org-tree-slide-slide-in t)
  (org-tree-slide-breadcrumbs " > ")
  :config
  ;; Ricalcola l'adattamento a ogni cambio di slide.
  (add-hook 'org-tree-slide-after-narrow-hook
            #'my/org-presentation-fit-slide))

(provide 'presentazione)
;;; presentazione.el ends here
