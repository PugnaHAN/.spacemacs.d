;;; packages.el --- juhan-better-defaults layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: HPCVS <turtlebot@turtlebot-HPCVS-Z600>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `juhan-better-defaults-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `juhan-better-defaults/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `juhan-better-defaults/pre-init-PACKAGE' and/or
;;   `juhan-better-defaults/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst juhan-better-defaults-packages
  '(dired)
  "The list of Lisp packages required by the juhan-better-defaults layer.q

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun juhan-better-defaults/post-init-dired()
  (progn
    (put 'dired-find-alternate-file 'disabled nil)
    (add-hook 'dired-mode-hook
              (lambda()
                (define-key dired-mode-map (kbd "<C-up>")
                  (lambda()
                    (interactive)
                    (find-alternate-file "..")))))
    (eval-after-load "dired"
      '(progn
         (defadvice dired-find-file (around dired-subst-directory activate)
           "Replace current buffer if file is a directory."
           (interactive)
           (let* ((orig (current-buffer))
                  ;; (filename (dired-get-filename))
                  (filename (dired-get-filename t t))
                  (bye-p (file-directory-p filename)))
             ad-do-it
             (when (and bye-p (not (string-match "[/\\\\]\\.$" filename)))
               (kill-buffer orig))))))))


;;; packages.el ends here
