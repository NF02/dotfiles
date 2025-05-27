(defun install-env ()
  "Environment install"
  (custom-set-variables 
   '(package-selected-packages
     '(
       auto-dark
       which-key
       ;; company mode
       company
       company-spell
       company-auctex
       company-ctags
       company-php
       company-web
       company-statistics
       company-c-headers
       company-math
       
       ;; latex
       auctex
       auctex-latexmk
       cdlatex
       latex-extra
       latex-math-preview
       yatex
       
       ;; org mode
       org-modern
       org-contrib
       org-roam
       org-roam-ui
       org-tree-slide
       org-re-reveal
       org-fragtog

       ;; babel
       ob-rust
       
       ;; (JAVA) processing mode
       processing-mode
       processing-snippets

       ;; Docker
       dockerfile-mode
       docker-cli
       docker-compose-mode
       docker-api
       
       ;; other
       slime
       powerline
       cobol-mode
       pdf-tools
       elfeed
       octave
       neotree
       vterm
       vterm-toggle
       )))
  (package-install-selected-packages nil))
(install-env)
