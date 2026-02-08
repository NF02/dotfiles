(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)     ; Il comando principale
         ("C-x M-g" . magit-dispatch) ; Menu rapido per azioni Git
         ("C-c L" . magit-log-buffer-file)) ; Log del file corrente
  :custom
  ;; Mostra Magit in una finestra a tutto schermo (molto più leggibile)
  (magit-display-buffer-function #'magit-display-buffer-fullcolumn-most-v1)
  ;; Salva automaticamente i buffer dei file quando fai il commit
  (magit-save-repository-buffers 'dontask))

(use-package diff-hl
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'diff-hl-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
