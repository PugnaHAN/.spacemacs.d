;;; packages.el --- juhan-c-c++ layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: NEIL_PC <Pugna_HAN@NEIL_PC.Home>
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
;; added to `juhan-c-c++-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `juhan-c-c++/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `juhan-c-c++/pre-init-PACKAGE' and/or
;;   `juhan-c-c++/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:
;
(defconst juhan-c-c++-packages
  '((google-c-style :location (recipe :fetcher github
                                      :repo google/styleguide
                                      :files ("google-c-style.el")))
    company
    company-c-headers
    irony
    company-irony
    )

  "The list of Lisp packages required by the juhan-c-c++ layer.

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


(defun juhan-c-c++/post-init-company()
  (setq company-idle-delay juhan-c-c++-company-idle-delay))

(defun juhan-c-c++/init-google-c-style ()
  ;; (message "Initialize google-c-style")
  (add-hook 'c-mode-common-hook 'google-set-c-style))

(defun juhan-c-c++/post-init-google-c-style()
  (with-eval-after-load 'google-c-style
    (progn
      (setq  c-default-style
             `((c++-mode . "google")
               (c-mode . "google")
               (java-mode . "java")
               (awk-mode . "awk")
               (other . "gnu")))

      (add-hook 'c-mode-hook (lambda()
                               (setq c-basic-offset 4
                                     indent-tabs-mode t)))
      (add-hook 'c++-mode-hook (lambda()
                                 (setq c-basic-offset 4
                                       indent-tabs-mode t)))))
      )

(defun juhan-c-c++/init-irony()
  (use-package "irony"
    :defer t
    :config
    (spacemacs/add-to-hooks 'irony-mode '(c-mode-hook c++-mode-hook))))

(defun juhan-c-c++/init-company-irony()
  (use-package "company-irony"
    :config
    (add-to-list 'company-backends-c-mode-common 'company-irony)))

;;; packages.el ends here
