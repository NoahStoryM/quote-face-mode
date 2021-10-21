;;; quote-face-mode.el --- Highlight ' ` , ,@ mode.

;; Copyright (C) 2021, 2021-2021 by Noah Ma <NoahStoryM@gmail.com>

;; Author: Noah Ma <NoahStoryM@gmail.com>
;; Maintainer: Noah Ma <NoahStoryM@gmail.com>
;; Keywords: faces
;; Version: 1.01

(defgroup quote-face nil
  "Face for ' ` , ,@ in lisp modes."
  :group 'font-lock-extra-types
  :group 'faces)

(defface lisp-quote-face '((t (:inherit font-lock-builtin-face)))
  "Face for ' ` , ,@ in lisp modes.
This face is only used if `quote-face-mode' is turned on.
See `global-quote-face-mode' for an easy way to do so."
  :group 'quote-face)

(defcustom quote-face-modes
  '(common-lisp-mode
    emacs-lisp-mode lisp-interaction-mode ielm-mode
    racket-mode racket-repl-mode scheme-mode inferior-scheme-mode
    clojure-mode cider-repl-mode nrepl-mode
    arc-mode inferior-arc-mode)
  "Major modes in which `quote-face-mode' should be turned on.
When `global-quote-face-mode' is turned on, the buffer-local mode
is turned on in all buffers whose major mode is or derives from
one of the modes listed here."
  :type '(repeat symbol)
  :group 'quote-face)

(defcustom quote-face-regexp (rx (seq (? ?#) (or "'" "`" ",@" ",")))
  "Regular expression to match ' ` , ,@ ."
  :type 'regexp
  :group 'quote-face)

(defcustom quote-face-mode-lighter ""
  "String to display in the mode line when `quote-face-mode' is active."
  :type 'string
  :group 'quote-face)

;;;###autoload
(define-minor-mode quote-face-mode
  "Use a dedicated face just for ' ` , ,@ ."
  :lighter quote-face-mode-lighter
  (let ((keywords `((,quote-face-regexp . 'lisp-quote-face))))
    (if quote-face-mode
        (font-lock-add-keywords  nil keywords t)
      (font-lock-remove-keywords nil keywords)))
  (when font-lock-mode
    (if (and (fboundp 'font-lock-flush)
             (fboundp 'font-lock-ensure))
        (save-restriction
          (widen)
          (font-lock-flush)
          (font-lock-ensure))
      (with-no-warnings
        (font-lock-fontify-buffer)))))

;;;###autoload
(define-globalized-minor-mode global-quote-face-mode
  quote-face-mode turn-on-quote-face-mode-if-desired
  :group 'quote-face)

(defun turn-on-quote-face-mode-if-desired ()
  (when (apply 'derived-mode-p quote-face-modes)
    (quote-face-mode 1)))


(provide 'quote-face-mode)
;; End:
;;; quote-face-mode.el ends here
