(defun add-ros-header-path-if-needed()
  "If there is a spefic version of ros being included in your system, add it into header path"
  (with-eval-after-load 'company-c-headers
    (let ((temp-c-header-path company-c-headers-path-system)
          (ros-header-path (format "/opt/ros/%s/include" juhan-c-c++-ros-version))
          (c++-header-path "/usr/include/c++/5.4.0/"))
      (when (file-exists-p ros-header-path)
        (setq-local company-c-headers-path-system
                    (progn 
                      (add-to-list 'temp-c-header-path ros-header-path)
                      (add-to-list 'temp-c-header-path c++-header-path)))))))

(defmacro juhan|toggle-company-backends (backend)
  "Push or delete the backend to company-backends"
  (let ((funsymbol (intern (format "juhan/company-toggle-%S" backend))))
    `(defun ,funsymbol ()
       (interactive)
       (if (eq (car company-backends) ',backend)
           (setq-local company-backends (delete ',backend company-backends))
         (push ',backend company-backends)))))
