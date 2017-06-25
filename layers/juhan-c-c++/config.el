(defvar juhan-c-c++-company-idle-delay 0.2
  "The company idle delay setting")

(defvar juhan-c-c++-ros-version "indigo"
  "Define the ros version to make header file can be added into path-separator")

(defvar juhan-c-c++-ycmd-path (expand-file-name "~/Workspace/Github/ycmd")
  "The c-c++ layer path of juhan")

(defvar juhan-c-c++-config-conf-path (expand-file-name "~/.local/bin/config_gen")
  "The config_conf script path for generating .ycm_extra_conf.py")

(defvar juhan-c-c++-cscope-update-option nil
  "If set it as nil, the database wouldn't be update when searching")

(if c-c++-enable-clang-support
    (advice-add 'c-c++/load-clang-args :after #'add-ros-header-path-if-needed)
  (add-hook 'c-mode-common-hook 'add-ros-header-path-if-needed))

;; Config my company-backends

