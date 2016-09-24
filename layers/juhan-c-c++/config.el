(defvar juhan-c-c++-company-idle-delay 0.2
  "The company idle delay setting")

(defvar juhan-c-c++-ros-version "indigo"
  "Define the ros version to make header file can be added into path-separator")

(message "Configure the c-++-mode-hook")
(advice-add 'c-c++/load-clang-args :after #'add-ros-header-path-if-needed)
