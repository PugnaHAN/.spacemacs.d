(defvar juhan-c-c++-company-idle-delay 0.2
  "The company idle delay setting")

(defvar juhan-c-c++-ros-version "indigo"
  "Define the ros version to make header file can be added into path-separator")

(add-hook 'c++-mode-hook
          'add-ros-header-path-if-needed)
