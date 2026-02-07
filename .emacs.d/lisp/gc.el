;; garbage collector
(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'after-init-hook
          (lambda ()
            (garbage-collect)
            (setq gc-cons-threshold (* 5 1024 1024))
            (setq gc-cons-threshold-last-value gc-cons-threshold)))
