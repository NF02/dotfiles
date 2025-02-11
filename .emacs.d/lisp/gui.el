;; powerline
(require 'powerline)
(powerline-default-theme)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; which key
(require 'which-key)
(which-key-mode)
(which-key-setup-minibuffer)

;; theme
;;(load-theme 'spacemacs-dark t)
;;; light theme
;(load-theme 'spacemacs-light t)
(require 'auto-dark)
(auto-dark-mode)
