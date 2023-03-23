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

  yay -S python python-pip

  # docker
  sudo pacman -S docker
  sudo systemctl enable docker

  # insomnia
  yay -S insomnia-bin
}

install_neovim () {
  cat <<EOF

###################################################
###                                             ###
###              INSTALLING NEOVIM              ###
###                                             ###
###################################################

EOF

  yay -S fzf ripgrep the_silver_searcher fd
  sudo pacman -S aspell aspell-en

  yarn global add vscode-langservers-extracted typescript typescript-language-server emmet-ls prettier @fsouza/prettierd pyright
  pip install yapf

  # Install Hack Nerd Font
  mkdir -p $HOME/Downloads/Compressed/
  curl -Lo $HOME/Downloads/Compressed/hack_nerd_font.zip 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip'
  sudo unzip $HOME/Downloads/Compressed/hack_nerd_font.zip -d /usr/share/fonts/TTF/
  rm -rf $HOME/Downloads/Compressed

  sudo pacman -S neovim

  cp -r $SCRIPT_DIR/.config/nvim $HOME/.config/
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

install_et () {
  cat <<EOF

###################################################
###                                             ###
###                INSTALLING ET                ###
###                                             ###
###################################################

EOF

  sudo pacman -S tre sox

  mkdir -p $HOME/Downloads
  git clone https://github.com/PlankCipher/et.git $HOME/Downloads/et
  cd $HOME/Downloads/et
  ./install.sh
  cd $SCRIPT_DIR
  rm -rf $HOME/Downloads/et
}

install_build_utils
install_yay
install_nodejs
install_misc_dev_stuff
install_neovim
install_et
copy_files_and_create_dirs

cat << EOF
__        __   _                               _                          _
\ \      / /__| | ___ ___  _ __ ___   ___     | |__   ___  _ __ ___   ___| |
 \ \ /\ / / _ \ |/ __/ _ \| '_ \` _ \ / _ \    | '_ \ / _ \| '_ \` _ \ / _ \ |
  \ V  V /  __/ | (_| (_) | | | | | |  __/    | | | | (_) | | | | | |  __/_|
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|    |_| |_|\___/|_| |_| |_|\___(_)
EOF
exit 0
