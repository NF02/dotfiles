;;; pdf-view-restore-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "pdf-view-restore" "pdf-view-restore.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from pdf-view-restore.el

(autoload 'pdf-view-restore-mode "pdf-view-restore" "\
Automatically restore last known pdf position

This is a minor mode.  If called interactively, toggle the
`Pdf-View-Restore mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `pdf-view-restore-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "pdf-view-restore" '("pdf-view-restore" "use-file-base-name-flag"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; pdf-view-restore-autoloads.el ends here
