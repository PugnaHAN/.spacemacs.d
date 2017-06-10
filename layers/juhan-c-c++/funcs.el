(defun add-ros-header-path-if-needed()
  "If there is a spefic version of ros being included in your system, add it into header path"
  (with-eval-after-load 'company-c-headers
    (let ((temp-c-header-path company-c-headers-path-system)
          (ros-header-path (format "/opt/ros/%s/include" juhan-c-c++-ros-version))
          (c++-header-path (juhan-c-c++/get-c++-header-path)))
      (when (file-exists-p ros-header-path)
        (setq-local company-c-headers-path-system
                    (add-to-list 'temp-c-header-path ros-header-path)))
      (setq-local company-c-headers-path-system
                  (progn 
                    (add-to-list 'temp-c-header-path c++-header-path)
                    (add-to-list 'temp-c-header-path "/usr/include/x86_64-linux-gnu")
                    )))))

       
(defmacro juhan|toggle-company-backends (backend)
  "Push or delete the backend to company-backends"
  (let ((funsymbol (intern (format "juhan/company-toggle-%S" backend))))
    `(defun ,funsymbol ()
       (interactive)
       (if (eq (car company-backends) ',backend)
           (setq-local company-backends (delete ',backend company-backends))
         (push ',backend company-backends)))))

(defun juhan-c-c++/get-c++-header-path()
  "Get the latest version of c++ header files"
  (let ((c++-header-path "/usr/include/c++/")
        (c++-versions )
        (final-version "4.8")
        (tmp-version "4.8"))
    (setq c++-versions (directory-files c++-header-path))
    (dolist (tmp-version c++-versions)
      (when (and (not (string-equal tmp-version "."))
                 (not (string-equal tmp-version "..")))
        ;; (message (format "tmp-version is %s"
        ;;                  tmp-version))
        (when (version< final-version tmp-version)
          (setq final-version tmp-version))))
    (concat c++-header-path final-version)))
