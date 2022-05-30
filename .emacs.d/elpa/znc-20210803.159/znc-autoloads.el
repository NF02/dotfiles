;;; znc-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "znc" "znc.el" (0 0 0 0))
;;; Generated autoloads from znc.el

(autoload 'znc-erc "znc" "\
Connect to a configured znc network

\(fn &optional NETWORK)" t nil)

(autoload 'znc-all "znc" "\
Connect to all known networks

\(fn &optional DISCONNECT)" t nil)

(register-definition-prefixes "znc" '("*znc-server-" "with-endpoint" "znc-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; znc-autoloads.el ends here
