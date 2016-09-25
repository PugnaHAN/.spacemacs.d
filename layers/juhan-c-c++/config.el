(defvar juhan-c-c++-company-idle-delay 0.2
  "The company idle delay setting")

(defvar juhan-c-c++-ros-version "indigo"
  "Define the ros version to make header file can be added into path-separator")

(defvar juhan-c-c++-layer-path (expand-file-name "~/Github/ycmd")
  "The c-c++ layer path of juhan")

(if c-c++-enable-clang-support
    (advice-add 'c-c++/load-clang-args :after #'add-ros-header-path-if-needed)
  (add-ros-header-path-if-needed))

;; Config my company-backends

