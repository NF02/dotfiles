;;; rhtml-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "rhtml-erb" "rhtml-erb.el" (0 0 0 0))
;;; Generated autoloads from rhtml-erb.el

(register-definition-prefixes "rhtml-erb" '("rhtml-" "skip-whitespace-forward"))

;;;***

;;;### (autoloads nil "rhtml-fonts" "rhtml-fonts.el" (0 0 0 0))
;;; Generated autoloads from rhtml-fonts.el

(register-definition-prefixes "rhtml-fonts" '("erb-type-to-" "rhtml-"))

;;;***

;;;### (autoloads nil "rhtml-mode" "rhtml-mode.el" (0 0 0 0))
;;; Generated autoloads from rhtml-mode.el

(autoload 'rhtml-mode "rhtml-mode" "\
Embedded Ruby Mode (RHTML)

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.html\\.erb$" . rhtml-mode))

(register-definition-prefixes "rhtml-mode" '("extract-partial" "rhtml-dashize"))

;;;***

;;;### (autoloads nil "rhtml-navigation" "rhtml-navigation.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from rhtml-navigation.el

(register-definition-prefixes "rhtml-navigation" '("current-line" "match-strings" "rails-root" "rhtml-" "rinari-find-by-context"))

;;;***

;;;### (autoloads nil "rhtml-ruby-hook" "rhtml-ruby-hook.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from rhtml-ruby-hook.el

(register-definition-prefixes "rhtml-ruby-hook" '("rhtml-" "rthml-insert-from-ruby-temp"))

;;;***

;;;### (autoloads nil "rhtml-sgml-hacks" "rhtml-sgml-hacks.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from rhtml-sgml-hacks.el

(register-definition-prefixes "rhtml-sgml-hacks" '("rhtml-" "sgml-"))

;;;***

;;;### (autoloads nil nil ("rhtml-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rhtml-mode-autoloads.el ends here
