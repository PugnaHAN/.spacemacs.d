;;; funcs.el --- juhan Layer packages File for Spacemacs
;;
;; Copyright (c) 2015-2016 juhan
;;
;; Author: juhan <guanghui8827@gmail.com>
;; URL: https://github.com/juhan/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3
(defun juhan/update-persp-name ()
  ;; `persp-mode' should be enabled before call it
  (when (bound-and-true-p persp-mode)
    ;; There are multiple implementations of
    ;; persp-mode with different APIs
    (progn
      (or (not (string= persp-nil-name (safe-persp-name (get-frame-persp))))
          "Default")
      (let ((name (safe-persp-name (get-frame-persp))))
        (propertize (concat "[" name "] ")
                    'face 'font-lock-preprocessor-face
                    'help-echo "Current Layout name.")))))

(defun spaceline--unicode-number (str)
  "Return a nice unicode representation of a single-digit number STR."
  (cond
   ((string= "1" str) "➊")
   ((string= "2" str) "➋")
   ((string= "3" str) "➌")
   ((string= "4" str) "➍")
   ((string= "5" str) "➎")
   ((string= "6" str) "➏")
   ((string= "7" str) "➐")
   ((string= "8" str) "➑")
   ((string= "9" str) "➒")
   ((string= "0" str) "➓")))

(defun window-number-mode-line ()
  "The current window number. Requires `window-numbering-mode' to be enabled."
  (when (bound-and-true-p window-numbering-mode)
    (let* ((num (window-numbering-get-number))
           ;; When the num is not nil, get its string
           (str (when num 
                  (int-to-string num))))
      (spaceline--unicode-number str))))

(defun mode-line-fill (face reserve)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when (and window-system (eq 'right (get-scroll-bar-mode)))
    (setq reserve (- reserve 3)))
  (propertize " "
              'display `((space :align-to
                                (- (+ right right-fringe right-margin) ,reserve)))
              'face face))

(defun buffer-encoding-abbrev ()
  "The line ending convention used in the buffer."
  (let ((buf-coding (format "%s" buffer-file-coding-system)))
    (if (string-match "\\(dos\\|unix\\|mac\\)" buf-coding)
        (match-string 1 buf-coding)
      buf-coding)))

(defun linum-format-func (line)
  "format the line linum to '  N' - the number with spaces to fit the width of max lines "
  (let ((w (length
            (number-to-string (count-lines (point-min) (point-max))))))
    (concat
     (propertize (make-string (- w (length (number-to-string line))) ? )
                 'face 'linum-leading-zero)
     (propertize (number-to-string line) 'face 'linum)
     "\u2502")))
