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

install_nodejs () {
  cat <<EOF

###################################################
###                                             ###
###              INSTALLING NODEJS              ###
###                                             ###
###################################################

EOF

  # NodeJS and YARN
  sudo pacman -S nodejs

  sudo corepack enable

  yarn config set init-license GPL-3.0-only -g
  yarn config set init-author-name PlankCipher -g

  yarn global add eslint-cli create-react-app
}

install_misc_dev_stuff () {
  cat <<EOF

###################################################
###                                             ###
###          INSTALLING MISC DEV STUFF          ###
###                                             ###
###################################################

EOF

  sudo pacman -S man-pages

  # docker
  sudo pacman -S docker
  sudo systemctl enable docker

  # insomnia
  yay -S insomnia-bin
}

copy_files_and_create_dirs () {
  cat <<EOF

###################################################
###                                             ###
###       COPYING FILES AND CREATING DIRS       ###
###                                             ###
###################################################

EOF

  mkdir -p $HOME/chamber_of_magic/junk/ $HOME/chamber_of_magic/test/
}

install_build_utils
install_yay
install_nodejs
install_misc_dev_stuff
copy_files_and_create_dirs

cat << EOF
__        __   _                               _                          _
\ \      / /__| | ___ ___  _ __ ___   ___     | |__   ___  _ __ ___   ___| |
 \ \ /\ / / _ \ |/ __/ _ \| '_ \` _ \ / _ \    | '_ \ / _ \| '_ \` _ \ / _ \ |
  \ V  V /  __/ | (_| (_) | | | | | |  __/    | | | | (_) | | | | | |  __/_|
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|    |_| |_|\___/|_| |_| |_|\___(_)
EOF
exit 0
