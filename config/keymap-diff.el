;;; Enhanced Magit diff for keymap files

(require 'magit)

;; Always show refined (word-level) hunks in diffs
(setq magit-diff-refine-hunk 'all)

;; Custom function to view keymap changes with maximum detail
(defun adv360/magit-diff-keymap ()
  "Show word-level diff for keymap file in magit.
Works with both vanilla Emacs and Doom Emacs."
  (interactive)
  (let ((default-directory (magit-toplevel)))
    ;; Use magit-diff-working-tree (works with Doom and newer magit)
    (if (fboundp 'magit-diff-working-tree)
        (magit-diff-working-tree nil
          (list "--word-diff=color"
                "--word-diff-regex=&[a-zA-Z0-9_]+|[a-zA-Z0-9_]+|[^[:space:]]"
                "--" "config/adv360.keymap"))
      ;; Fallback to basic magit-diff with ARGS
      (magit-diff nil nil
        (list "--word-diff=color"
              "--word-diff-regex=&[a-zA-Z0-9_]+|[a-zA-Z0-9_]+|[^[:space:]]"
              "--" "config/adv360.keymap")))))

;; Bind to 'K' in magit-status for quick access
(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "K") 'adv360/magit-diff-keymap))

;; Optional: Quick command to see what changed
(defun adv360/what-changed-in-keymap ()
  "Show a quick word-diff of keymap changes."
  (interactive)
  (let ((default-directory (magit-toplevel)))
    (shell-command
     "git diff --word-diff=plain --word-diff-regex='&[a-zA-Z0-9_]+|[a-zA-Z0-9_]+|[^[:space:]]' config/adv360.keymap"
     "*Keymap Changes*")
    (pop-to-buffer "*Keymap Changes*")
    (diff-mode)))

(global-set-key (kbd "C-c k d") 'adv360/what-changed-in-keymap)

;;; Ediff configuration for visual keymap comparison

;; Quick ediff comparison with HEAD
(defun adv360/ediff-keymap-with-head ()
  "Compare current keymap with HEAD using ediff.
  Shows two windows side-by-side with character-level diff highlighting.

  Navigation keys in ediff control panel:
  - n/p: next/previous difference
  - a/b: copy version A or B to the other
  - q: quit ediff"
  (interactive)
  (let ((file "config/adv360.keymap"))
    (if (file-exists-p file)
        (vc-ediff file)
      (error "Keymap file not found: %s" file))))

;; Enhanced ediff with word-mode toggle
(defun adv360/ediff-keymap-word-mode ()
  "Compare keymap with HEAD using word-wise ediff.
  This shows differences at the word level rather than line level."
  (interactive)
  (let* ((file "config/adv360.keymap")
         (buf-a (get-buffer-create "*keymap-HEAD*"))
         (buf-b (find-file-noselect file)))
    ;; Get HEAD version
    (with-current-buffer buf-a
      (erase-buffer)
      (insert (shell-command-to-string
               (format "git show HEAD:%s" file))))
    ;; Start ediff in word mode
    (let ((ediff-word-mode t))
      (ediff-buffers buf-a buf-b))))

;; Make ediff show character-level differences by default
(setq-default ediff-forward-word-function 'forward-char)
(setq-default ediff-highlight-all-diffs t)

;; Add toggle function for active ediff sessions
(defun adv360/ediff-toggle-word-mode ()
  "Toggle between line and word diff in active ediff session."
  (interactive)
  (when (bound-and-true-p ediff-word-mode)
    (setq ediff-word-mode (not ediff-word-mode))
    (ediff-update-diffs)))

;; Bind keys for easy access
(global-set-key (kbd "C-c k e") 'adv360/ediff-keymap-with-head)
(global-set-key (kbd "C-c k E") 'adv360/ediff-keymap-word-mode)

;; Hook to add toggle key in ediff control panel
(add-hook 'ediff-startup-hook
          (lambda ()
            (define-key ediff-mode-map (kbd ".")
              'adv360/ediff-toggle-word-mode)))
