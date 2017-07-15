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

(defun juhan-c-c++/generate-ycmd-extra-conf()
  "Generate the local extra conf by using YCM-Generator"
  (interactive)
  (let* ((config-gen-path juhan-c-c++-config-conf-path)
         (output-path (read-string "Enter the .ycm_extra_conf.py output path: "))
         (whole-command (concat config-gen-path
                                " -o "
                                (if (string-equal output-path "")
                                    "." config-gen-path)))
         (temp-buffer-name "*ycm-generator-output*"))
    (with-output-to-temp-buffer temp-buffer-name
      (shell-command whole-command temp-buffer-name)
      (pop-to-buffer temp-buffer-name))))

(defun juhan-c-c++/get-symbol-index-in-line(sym)
  "get the symbol position in a line"
  (let* ((start (line-beginning-position))
         (end (line-end-position))
         (c (char-after start))
         (p start))
    (catch 'sym
      (if (char-or-string-p sym)
          (setq sym (string-to-char sym))
        (throw 'sym nil)))
    (while (and (< p end) (not (char-equal c sym)))
      (goto-char p)
      (setq c (char-after p))
      (message "current char is %c" c)
      (setq p (+ p 1)))
    (return (- p start))))

(defun juhan-c-c++/max-num-in-list(list)
  "get the maxium number in a list"
  (catch 'list
    (let ((result 0))
      (dolist (var list)
        (if (numberp var)
            (setq result (if (> result var)  result
                           var))
          (throw 'list nil)))
      result)))
