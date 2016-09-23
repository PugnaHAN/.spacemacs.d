(defun add-ros-header-path-if-needed()
  "Add the ros indigo include path into c-header-path"
  (let ((ros-header-path (format "/opt/ros/%s/include" juhan-c-c++-ros-version)))
    (when (file-exists-p ros-header-path)
      (add-to-list 'company-c-headers-path-system))))
