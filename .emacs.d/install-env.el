(defun install-env ()
  "Environment install"
  (custom-set-variables 
   '(package-selected-packages
     '(
       timu-spacegrey
       ;; company mode
       company
       company-spell
       company-auctex
       company-ctags
       company-php
       company-web
       company-statistics
       company-c-headers

       ;; latex
       auctex

       ;; org mode
       org-modern
       org-contrib
       org-roam
       org-roam-ui
       org-tree-slide
       org-re-reveal

       ;; JAVA
       lsp-ui
       lsp-java
       lsp-treemacs
       dap-mode
       dap-java
       helm-lsp
       helm
       yasnippet
       flycheck
       hydra
       projectile
       
       ;; (JAVA) processing mode
       processing-mode
       processing-snippets
       ;; other
       slime
       powerline
       cobol-mode
       pdf-tools
       elfeed
       octave
       neotree
       vterm
       vterm-toggle)))
  (package-install-selected-packages nil))
(install-env)
