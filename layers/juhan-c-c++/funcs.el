(defun add-ros-header-path-if-needed()
  "If there is a spefic version of ros being included in your system, add it into header path"
  (with-eval-after-load 'company-c-headers
    (let ((temp-c-header-path company-c-headers-path-system)
          (ros-header-path (format "/opt/ros/%s/include" juhan-c-c++-ros-version))
          (c++-header-path "/usr/include/c++/4.8.4/"))
      (when (file-exists-p ros-header-path)
        (setq-local company-c-headers-path-system
                    (prog2
                      (add-to-list 'temp-c-header-path ros-header-path)
                      (add-to-list 'temp-c-header-path c++-header-path)))))))
