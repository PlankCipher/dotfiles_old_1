#!/bin/bash

SCRIPT_DIR=$(pwd)

install_build_utils () {
  cat <<EOF

###################################################
###                                             ###
###            INSTALLING BUILD UTILS           ###
###                                             ###
###################################################

EOF

  sudo pacman -Syu git base-devel make qt5-tools qt5-base gcc wget clang
}

install_yay () {
  cat <<EOF

###################################################
###                                             ###
###               INSTALLING YAY                ###
###                                             ###
###################################################

EOF

  sudo git clone https://aur.archlinux.org/yay-git.git /opt/yay-git
  sudo chown -R $(whoami):$(whoami) /opt/yay-git
  cd /opt/yay-git
  makepkg -si
  cd $SCRIPT_DIR
}

install_build_utils
install_yay

cat << EOF
__        __   _                               _                          _
\ \      / /__| | ___ ___  _ __ ___   ___     | |__   ___  _ __ ___   ___| |
 \ \ /\ / / _ \ |/ __/ _ \| '_ \` _ \ / _ \    | '_ \ / _ \| '_ \` _ \ / _ \ |
  \ V  V /  __/ | (_| (_) | | | | | |  __/    | | | | (_) | | | | | |  __/_|
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|    |_| |_|\___/|_| |_| |_|\___(_)
EOF
exit 0
