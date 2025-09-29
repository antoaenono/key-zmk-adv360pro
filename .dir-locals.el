;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((eval . (when (and (buffer-file-name)
                            (not (bound-and-true-p adv360-keymap-diff-loaded)))
                  (let ((config-file (expand-file-name "config/keymap-diff.el"
                                                        (locate-dominating-file default-directory ".git"))))
                    (when (file-exists-p config-file)
                      (load-file config-file)
                      (setq-local adv360-keymap-diff-loaded t)
                      (message "ADV360 keymap-diff configuration loaded"))))))))
