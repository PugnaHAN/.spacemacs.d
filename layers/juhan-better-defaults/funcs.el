(defun transpose-windows ()
  "Swap window when there are only two window"
  (interactive)
  (let ((this-buffer (window-buffer (selected-window)))
        (other-buffer (window-buffer (next-window))))
    (switch-to-buffer other-buffer)
    (switch-to-buffer-other-window this-buffer)
    (other-window -1)))

(defun clear-recentf()
  "Clean the recent file which doesn't exist"
  (dolist (file recentf-list)
    (if (not (file-exists-p file))
        (delete file recentf-list))))       

