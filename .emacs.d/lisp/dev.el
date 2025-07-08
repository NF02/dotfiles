;; Octave
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1)))
	 'display-line-numbers-mode)

;; vterm
(require 'vterm)
(require 'vterm-toggle)
(global-set-key [C-f5] 'vterm-toggle-cd)

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

;; slime
(require 'slime)
(setq inferior-lisp-program "sbcl")

;; processing
(setq processing-location "~/.local/processing-4.3/processing-java")
(setq processing-application-dir "~/.local/processing-4.3/processing")
(setq processing-sketchbook-dir "~/Documenti/processing")

;; docker
(require 'dockerfile-mode)
(require 'docker-cli)
(setq dockerfile-mode-command "docker")
