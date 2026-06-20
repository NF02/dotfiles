;;; web.el --- Web development configuration  -*- lexical-binding: t; -*-

(use-package web-mode
  :ensure t
  :mode (("\\.phtml\\'"      . web-mode)
         ("\\.tpl\\.php\\'"  . web-mode)
         ("\\.[agj]sp\\'"    . web-mode)
         ("\\.as[cp]x\\'"    . web-mode)
         ("\\.erb\\'"        . web-mode)
         ("\\.mustache\\'"   . web-mode)
         ("\\.djhtml\\'"     . web-mode)
         ("\\.html?\\'"      . web-mode)
         ("\\.jsx\\'"        . web-mode)
         ("\\.tsx\\'"        . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-current-element-highlight t
        web-mode-enable-auto-quoting t
        web-mode-enable-auto-indentation t)

  (setq web-mode-engines-alist '(("php" . "\\.phtml\\'"))))

(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode)
  :config
  (setq emmet-move-cursor-between-quotes t))

(use-package php-mode
  :ensure t
  :mode ("\\.php\\'" . php-mode)
  :config
  (defun my/php-shell ()
    (interactive)
    (if (get-buffer "*php-shell*")
        (switch-to-buffer "*php-shell*")
      (progn
        (make-comint-in-buffer "php-shell" "*php-shell*" "php" nil "-a")
        (switch-to-buffer "*php-shell*")))))

(use-package hugoista
  :ensure t
  :custom
  (hugoista-site-dir (expand-file-name "~/repos/mio-sito")))

(provide 'web)
