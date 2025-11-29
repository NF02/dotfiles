(use-package octave-mode
  :ensure t
  :mode ("\\.m\\'" . octave-mode)
  :config
  (add-hook 'octave-mode-hook
            (lambda ()
              ;; Abilita le abbreviazioni per espansione del testo
              (abbrev-mode 1)
              (auto-fill-mode 1) 
              (display-line-numbers-mode 1)               
              (local-set-key (kbd "RET") 'newline-and-indent)
              ))
  )

;; eat
(require 'eat)
(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode)
  :config
  ;; Abilita l'annotazione del prompt (utile in Eshell + Eat)
  (setq eat-shell-prompt-annotation t)
  
  ;; Disabilita (o abilita se preferisci) la possibilità che le app del terminale
  ;; uccidano il testo senza interazione utente.
  (setq eat-enable-kill-from-terminal nil) 
  
  ;; Abilita il supporto Sixel per le immagini
  (when (fboundp 'sixel-display-mode)
    (sixel-display-mode 1)
    (setq eat-sixel-enabled t)))

;; neotree
(require 'neotree)
(global-set-key [f5] 'neotree-toggle)
(global-set-key (kbd "C-c r") 'neotree-refresh)

;; gnu cobol
(require 'cobol-mode)
(setq auto-mode-alist
      (append
       '(("\\.cob\\'" . cobol-mode)
         ("\\.cbl\\'" . cobol-mode)
         ("\\.cpy\\'" . cobol-mode))
       auto-mode-alist))

;; SLIME (Superior Lisp Interaction Mode for Emacs) configuration for Arch Linux.
(use-package slime
  :ensure nil ; SLIME is installed via the Arch Linux system package (pacman -S slime), not MELPA.
  :init
  ;; 1. Set the path to the Common Lisp executable (SBCL is standard on Arch)
  (setq inferior-lisp-program "/usr/bin/sbcl")
  
  ;; 2. Add the Arch Linux system path to find the SLIME Lisp files
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
  
  ;; 3. Define the keyboard shortcut (bind C-c s to the main SLIME function)
  :bind
  ("C-c s" . slime) ; Use the 'slime' function to start and connect to the Lisp process
  
  :config
  ;; Run the standard SLIME setup to initialize features and keybindings
  (slime-setup))

;; --- To start SLIME and connect to SBCL ---
;; Press C-c s (Control-c followed by s)

;; processing
(setq processing-location "~/.local/processing-4.3/processing-java")
(setq processing-application-dir "~/.local/processing-4.3/processing")
(setq processing-sketchbook-dir "~/Documenti/processing")

;; docker
(require 'dockerfile-mode)
(require 'docker-cli)
(setq dockerfile-mode-command "docker")
