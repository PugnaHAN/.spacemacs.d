;; Use the C-j to replace Enter
(global-set-key (kbd "C-j") 'newline-and-indent)
(global-set-key (kbd "RET") 'electric-newline-and-maybe-indent)

;; Disable the keybinding to avoid the white screen issue on Xmanager
;; (global-set-key (kbd "<C-down-mouse-1>") nil)
;; (global-set-key (kbd "<C-down-mouse-3>") nil)
