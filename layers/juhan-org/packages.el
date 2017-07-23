;;; packages.el --- juhan-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: NEIL_PC <Pugna_HAN@NEIL_PC>
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
;; added to `juhan-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `juhan-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `juhan-org/pre-init-PACKAGE' and/or
;;   `juhan-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst juhan-org-packages
  '((org :location built-in)
    (plantuml-mode)
    (flycheck-plantuml)
    )
  "The list of Lisp packages required by the juhan-org layer.

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

(defun juhan-org/post-init-org()
  (setq truncate-lines nil)
  (setq org-startup-folded nil)
  ;; set the default user-full-name & user-mail-address to help to generate template
  (setq-default user-full-name "Juhan Zhang")
  (setq-default user-mail-address "juhan.zhang@hannto.com")
  ;; add the .txt and .org_archive to auto-mode-list
  (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
  ;; add the plantuml into babel languages
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((python . t) (emacs-lisp . t) (dot . t) (plantuml . t)))
  (setq org-plantuml-jar-path juhan-org-plantuml-jar-path)
  )

(defun juhan-org/init-plantuml-mode()
  (use-package plantuml-mode
    :defer t))

(defun juhan-org/post-init-plantuml-mode()  
  (setq-default plantuml-jar-path juhan-org-plantuml-jar-path)
  (add-to-list 'auto-mode-alist '("\\.\\(plantuml\\|uml\\)$" . plantuml-mode))
  (with-eval-after-load 'org
    (add-to-list 'org-src-lang-modes `("plantuml" . plantuml)))
)

(defun juhan-org/init-flycheck-plantuml()
  (use-package flycheck-plantuml
    :defer t
    ))

(defun juhan-org/post-init-flycheck-plantuml()
  (with-eval-after-load 'flycheck
    (flycheck-plantuml-setup)
    (add-hook 'plantuml-mode-hook 'flycheck-mode)))

;;; packages.el ends here
