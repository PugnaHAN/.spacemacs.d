;;; packages.el --- zilong-ui layer packages file for Spacemacs.
;;
;; Copyright (c) 2014-2016 juhan
;;
;; Author: guanghui <guanghui8827@gmail.com>
;; URL: https://github.com/juhan/spacemacs-private
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
;; added to `zilong-ui-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `zilong-ui/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `zilong-ui/pre-init-PACKAGE' and/or
;;   `zilong-ui/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst juhan-ui-packages
  '(
    (zilong-mode-line :location built-in)
    diminish
    popwin
    (whitespace :location built-in)
    ;; if you wnat to use spaceline, please comment out zilong-mode-line
    spaceline
    ;; beacon
    ;; evil-vimish-fold
    company
    (font-config :location built-in)
    (face-config :location built-in)
    powerline
    linum
    )
  )

(defun juhan-ui/init-zilong-mode-line ()
  (setq my-flycheck-mode-line
        '(:eval
          (pcase flycheck-last-status-change
            ((\` not-checked) nil)
            ((\` no-checker) (propertize " -" 'face 'warning))
            ((\` running) (propertize " ✷" 'face 'success))
            ((\` errored) (propertize " !" 'face 'error))
            ((\` finished)
             (let* ((error-counts (flycheck-count-errors flycheck-current-errors))
                    (no-errors (cdr (assq 'error error-counts)))
                    (no-warnings (cdr (assq 'warning error-counts)))
                    (face (cond (no-errors 'error)
                                (no-warnings 'warning)
                                (t 'success))))
               (propertize (format "[%s/%s]" (or no-errors 0) (or no-warnings 0))
                           'face face)))
            ((\` interrupted) " -")
            ((\` suspicious) '(propertize " ?" 'face 'warning)))))

  ;; Delete the which-fun-mode info from mode line becuase it is displayed
  ;; in the first line
  (setq-default mode-line-misc-info
                (assq-delete-all 'which-func-mode mode-line-misc-info))

  (setq-default mode-line-format
                (list
                 " %1"
                 '(:eval (propertize
                          (window-number-mode-line)
                          'face
                          'font-lock-type-face))
                 " "
                 '(:eval (juhan/update-persp-name))

                 "%1 "
                 ;; the buffer name; the file name as a tool tip
                 '(:eval (propertize "%b " 'face 'font-lock-keyword-face
                                     'help-echo (buffer-file-name)))

                 " [" ;; insert vs overwrite mode, input-method in a tooltip
                 '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
                                     'face 'font-lock-preprocessor-face
                                     'help-echo (concat "Buffer is in "
                                                        (if overwrite-mode
                                                            "overwrite"
                                                          "insert") " mode")))

                 ;; was this buffer modified since the last save?
                 '(:eval (when (buffer-modified-p)
                           (concat "," (propertize "Mod"
                                                   'face 'font-lock-warning-face
                                                   'help-echo "Buffer has been modified"))))

                 ;; is this buffer read-only?
                 '(:eval (when buffer-read-only
                           (concat "," (propertize "RO"
                                                   'face 'font-lock-type-face
                                                   'help-echo "Buffer is read-only"))))
                 "] "

                 ;; anzu
                 anzu--mode-line-format

                 ;; relative position, size of file
                 "["
                 (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
                 "/"
                 (propertize "%I" 'face 'font-lock-constant-face) ;; size
                 "] "

                 ;; the current major mode for the buffer.
                 '(:eval (propertize "%m" 'face 'font-lock-string-face
                                     'help-echo buffer-file-coding-system))

                 "%1 "
                 my-flycheck-mode-line
                 "%1 "
                 ;; evil state
                 '(:eval evil-mode-line-tag)

                 ;; minor modes
                 '(:eval (when (> (window-width) 80)
                           minor-mode-alist))
                 " "
                 ;; git info
                 '(:eval (when (> (window-width) 120)
                           `(vc-mode vc-mode)))

                 " "

                 ;; global-mode-string goes in mode-line-misc-info
                 '(:eval (when (> (window-width) 120)
                           mode-line-misc-info))

                 (mode-line-fill 'mode-line 20)

                 ;; line and column
                 "(" ;; '%02' to set to 2 chars at least; prevents flickering
                 (propertize "%02l" 'face 'font-lock-type-face)
                 ","
                 (propertize "%02c" 'face 'font-lock-type-face)
                 ") "

                 '(:eval (when (> (window-width) 90)
                           (buffer-encoding-abbrev)))
                 " "
                 ;; add the time, with the date and the emacs uptime in the tooltip
                 '(:eval (propertize (format-time-string "%H:%M")
                                     'help-echo
                                     (concat (format-time-string "%c; ")
                                             (emacs-uptime "Uptime:%hh"))))
                 mode-line-end-spaces
                 )))

(defun juhan-ui/post-init-diminish()
  (progn
    (with-eval-after-load 'whitespace
      (diminish 'whitespace-mode))
    (with-eval-after-load 'smartparens
      (diminish 'smartparens-mode))
    (with-eval-after-load 'which-key
      (diminish 'which-key-mode))
    (with-eval-after-load 'hungry-delete
      (diminish 'hungry-delete-mode))
    (with-eval-after-load 'company-mode
      (diminish 'company-mode " ⓒc"))
    ))

(defun juhan-ui/post-init-spaceline ()
  (use-package spaceline-config
    :config
    (progn
      (defvar spaceline-org-clock-format-function
        'org-clock-get-clock-string
        "The function called by the `org-clock' segment to determine what to show.")

      (spaceline-define-segment org-clock
        "Show information about the current org clock task.  Configure
`spaceline-org-clock-format-function' to configure. Requires a currently running
org clock.
This segment overrides the modeline functionality of `org-mode-line-string'."
        (when (and (fboundp 'org-clocking-p)
                   (org-clocking-p))
          (substring-no-properties (funcall spaceline-org-clock-format-function)))
        :global-override org-mode-line-string)

      (spaceline-compile
       'zilong
       ;; Left side of the mode line (all the important stuff)
       '(((persp-name
           workspace-number
           window-number
           )
          :separator "|"
          :face highlight-face)
         ((buffer-modified buffer-size input-method))
         anzu
         '(buffer-id remote-host buffer-encoding-abbrev)
         ((point-position line-column buffer-position selection-info)
          :separator " | ")
         major-mode
         process
         (flycheck-error flycheck-warning flycheck-info)
         ;; (python-pyvenv :fallback python-pyenv)
         ((minor-modes :separator spaceline-minor-modes-separator) :when active)
         (org-pomodoro :when active)
         (org-clock :when active)
         nyan-cat)
       ;; Right segment (the unimportant stuff)
       '((version-control :when active)
         battery))

      (setq-default mode-line-format '("%e" (:eval (spaceline-ml-zilong))))
      )))

(defun juhan-ui/init-beacon ()
  (use-package beacon
    :init
    (progn
      (spacemacs|add-toggle beacon
        :status beacon-mode
        :on (beacon-mode)
        :off (beacon-mode -1)
        :documentation "Enable point highlighting after scrolling"
        :evil-leader "otb")

      (spacemacs/toggle-beacon-on))
    :config (spacemacs|hide-lighter beacon-mode)))

(defun juhan-ui/init-evil-vimish-fold ()
  (use-package evil-vimish-fold
    :init
    (vimish-fold-global-mode 1)
    :config
    (progn
      (define-key evil-normal-state-map (kbd "zf") 'vimish-fold)
      (define-key evil-visual-state-map (kbd "zf") 'vimish-fold)
      (define-key evil-normal-state-map (kbd "zd") 'vimish-fold-delete)
      (define-key evil-normal-state-map (kbd "za") 'vimish-fold-toggle))))

(defun juhan-ui/post-init-hl-anything ()
  (progn
    (hl-highlight-mode -1)
    (spacemacs|add-toggle toggle-hl-anything
      :status hl-highlight-mode
      :on (hl-highlight-mode)
      :off (hl-highlight-mode -1)
      :documentation "Toggle highlight anything mode."
      :evil-leader "ths")))

(defun juhan-ui/post-init-pangu-spacing ()
  (progn
    ;; add toggle options
    (spacemacs|add-toggle toggle-pangu-spaceing
      :status pangu-spacing-mode
      :on (global-pangu-spacing-mode)
      :off (global-pangu-spacing-mode -1)
      :documentation "Toggle pangu spacing mode"
      :evil-leader "ots")
    (add-hook 'markdown-mode-hook
              '(lambda ()
                 (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))))

(defun juhan-ui/post-init-popwin ()
  (progn
    (push "*juhan/run-current-file output*" popwin:special-display-config)
    (delete "*Async Shell Command*" popwin:special-display-config)))

(defun juhan-ui/post-init-whitespace ()
  (progn
    ;; http://emacsredux.com/blog/2013/05/31/highlight-lines-that-exceed-a-certain-length-limit/
    (setq whitespace-line-column fill-column) ;; limit line length
    ;;https://www.reddit.com/r/emacs/comments/2keh6u/show_tabs_and_trailing_whitespaces_only/
    (setq whitespace-display-mappings
          ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
          '(
            (space-mark 32 [183] [46])           ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP
            (newline-mark 10 [182 10])           ; 10 LINE FEED
            (tab-mark 9 [187 9] [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
            ))
    (setq whitespace-style '(face tabs trailing tab-mark ))
    ;; (setq whitespace-style '(face lines-tail))
    ;; show tab;  use untabify to convert tab to whitespace
    (setq spacemacs-show-trailing-whitespace nil)
    (setq whitespace-line-column 90)

    (setq-default tab-width 4)
    ;; (set-buffer-file-coding-system 'utf-8)
    ;; set-buffer-file-coding-system -> utf8 to convert dos to utf8
    ;; (setq inhibit-eol-conversion t)
    ;; (add-hook 'prog-mode-hook 'whitespace-mode)

    ;; (global-whitespace-mode +1)

    (with-eval-after-load 'whitespace
      (progn
        (set-face-attribute 'whitespace-tab nil
                            :background "#Adff2f"
                            :foreground "#00a8a8"
                            :weight 'bold)
        (set-face-attribute 'whitespace-trailing nil
                            :background "#e4eeff"
                            :foreground "#183bc8"
                            :weight 'normal)))

    (diminish 'whitespace-mode)))

;; Define my company mode face
(defun juhan-ui/post-init-company()
  (let ((dark-primary-color "#512DA8")
        (primary-color "#673AB7")
        (light-primary-color "#D1C4E9")
        (pure-white "#FFFFFF")
        (accent-color "#607D8B")
        (primary-text "#212121")
        (secondary-text "#757575")
        (divider-color "#BDBDBD"))
    (custom-set-faces
     `(company-tooltip ((t (:background ,primary-color))))
     `(company-scollbar-bg ((t (:background ,dark-primary-color))))
     `(company-scrollbar-fg ((t (:background ,light-primary-color))))
     `(company-tooltip-selection ((t (:background ,accent-color
                                                  :forground ,primary-text))))
     `(company-tooltip-common ((t (:background ,secondary-text)))))))

;; Init the table can be aligned in org mode
(defun juhan-ui/init-font-config()
  "Use Input Mono Compressed:13 and Noto Sans Mono Hei CJK TC:14 to align the fonts width"
  (when (window-system)
    (let ((ft-family (if (string-equal system-type "gnu/linux")
                         "Noto Sans Mono CJK TC"
                       "Microsoft Yahei")))
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                          charset
                          (font-spec :family ft-family :size 14)))))
  )

;; configure some ui settings
(defun juhan-ui/init-face-config()
  "Mass configuration of ui settings"
  ;; Global settings
  (setq-default fill-column 90)
  ;; set the cursor type
  (with-eval-after-load 'evil
    (setq-default evil-emacs-state-cursor '("skyblue" bar)))

  ;; for fixing powerline separator issue
  ;; (setq-default ns-use-srgb-colorspace nil)

  ;; http://emacsredux.com/blog/2014/04/05/which-function-mode/
  (which-function-mode)
  ;; when editing js file, this feature is very useful
  (setq-default header-line-format
                '((which-func-mode ("" which-func-format " "))))

  ;; more useful frame title, that show either a file or a
  ;; buffer name (if the buffer isn't visiting a file)
  (setq frame-title-format
        '("" " Pugna_HAN - "
          (:eval (if (buffer-file-name)
                     (abbreviate-file-name (buffer-file-name)) "%b"))))

  (define-fringe-bitmap 'right-curly-arrow
    [#b00000000
     #b00000000
     #b00000000
     #b00000000
     #b01110000
     #b00010000
     #b00010000
     #b00000000])

  (define-fringe-bitmap 'left-curly-arrow
    [#b00000000
     #b00001000
     #b00001000
     #b00001110
     #b00000000
     #b00000000
     #b00000000
     #b00000000])
  )

;; Set the powerline style
(defun juhan-ui/post-init-powerline()
  (setq powerline-default-separator 'arrow))

;; Set linum format 
(defun juhan-ui/post-init-linum()
  (defface linum-leading-zero
    `((t :inherit 'linum
         :foreground ,(face-attribute 'linum :background nil t)
         :family "InputMono" :size 14))
    "Face for displaying leading zeroes for line numbers in display margin."
    :group 'linum)
  (setq linum-format 'linum-format-func)
  (add-hook 'prog-mode-hook 'linum-mode)
)
