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

  sudo pacman -S man-pages man-db

  yay -S python python-pip

  sudo pacman -S docker
  sudo systemctl enable docker

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
  curl -Lo $HOME/Downloads/Compressed/hack_nerd_font.zip 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip'
  sudo unzip $HOME/Downloads/Compressed/hack_nerd_font.zip -d /usr/share/fonts/TTF/
  rm -rf $HOME/Downloads/Compressed/*

  sudo pacman -S neovim

  cp -r $SCRIPT_DIR/.config/nvim $HOME/.config/
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

  git clone https://github.com/PlankCipher/et.git $HOME/Downloads/et
  cd $HOME/Downloads/et
  ./install.sh
  cd $SCRIPT_DIR
  rm -rf $HOME/Downloads/et
}

install_ranger () {
  cat <<EOF

###################################################
###                                             ###
###              INSTALLING RANGER              ###
###                                             ###
###################################################

EOF

  yay -S ranger

  # Install dragon
  git clone https://github.com/mwh/dragon.git $HOME/Downloads/dragon
  cd $HOME/Downloads/dragon/
  sudo make install
  sudo chmod +x dragon
  sudo mv dragon /sbin/dragon
  cd $SCRIPT_DIR
  rm -rf $HOME/Downloads/dragon

  cp -r $SCRIPT_DIR/.config/ranger $HOME/.config/

  # Install ranger_devicons plugin
  git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins/ranger_devicons
}

install_kabmat () {
  cat <<EOF

###################################################
###                                             ###
###              INSTALLING KABMAT              ###
###                                             ###
###################################################

EOF

  git clone https://github.com/PlankCipher/kabmat.git $HOME/Downloads/kabmat
  cd $HOME/Downloads/kabmat
  make
  sudo make install
  cd $SCRIPT_DIR
  rm -rf $HOME/Downloads/kabmat
}

install_mpd () {
  cat <<EOF

###################################################
###                                             ###
###                INSTALLING MPD               ###
###                                             ###
###################################################

EOF

  yay -S mpd mpc ncmpcpp

  # Add mpd to required groups
  sudo gpasswd -a mpd $(whoami)
  chmod 710 $HOME/
  sudo gpasswd -a mpd audio

  cp -r $SCRIPT_DIR/.config/mpd $SCRIPT_DIR/.config/ncmpcpp $HOME/.config/
}

install_zsh_and_ohmyzsh () {
  cat <<EOF

###################################################
###                                             ###
###         INSTALLING ZSH AND OHMYZSH          ###
###                                             ###
###################################################

EOF

  yay -S zsh

  # Change default shell to ZSH
  chsh -s /usr/bin/zsh

  cp -r $SCRIPT_DIR/.config/zsh $HOME/.config/
  cp $SCRIPT_DIR/zsh/.zprofile $HOME/

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

  cp $SCRIPT_DIR/zsh/steeef.zsh-theme $HOME/.oh-my-zsh/themes/steeef.zsh-theme

  # Install zsh-autosuggestions plugin
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  # Install zsh-syntax-highlighting plugin
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # Install colorscripts
  yay -S shell-color-scripts
  xargs -a $SCRIPT_DIR/zsh/blacklisted_colorscripts.txt -I {} sh -c 'colorscript --blacklist {}'
}

copy_files_and_create_dirs () {
  cat <<EOF

###################################################
###                                             ###
###       COPYING FILES AND CREATING DIRS       ###
###                                             ###
###################################################

EOF

  mkdir -p $HOME/chamber_of_magic/{junk,test}

  mkdir -p $HOME/Downloads/{Music,Documents,Compressed}

  export GNUPGHOME="$HOME/.local/share/gnupg"
  mkdir -p $GNUPGHOME

  mkdir -p $HOME/.local/share/zsh
  touch $HOME/.local/share/zsh/history

  mkdir -p $HOME/.config/

  cp -r $SCRIPT_DIR/.config/fontconfig $SCRIPT_DIR/.config/git $SCRIPT_DIR/.config/gtk-2.0 $SCRIPT_DIR/.config/gtk-3.0 $HOME/.config/
  cp -r $SCRIPT_DIR/.scripts $HOME/
}

install_kitty () {
  cat <<EOF

###################################################
###                                             ###
###               INSTALLING KITTY              ###
###                                             ###
###################################################

EOF

  sudo pacman -S kitty
  cp -r $SCRIPT_DIR/.config/kitty $HOME/.config/
}

install_rofi () {
  cat <<EOF

###################################################
###                                             ###
###               INSTALLING ROFI               ###
###                                             ###
###################################################

EOF

  yay -S rofi-lbonn-wayland-git
  cp -r $SCRIPT_DIR/.config/rofi $HOME/.config/
}

install_waybar () {
  cat <<EOF

###################################################
###                                             ###
###              INSTALLING WAYBAR              ###
###                                             ###
###################################################

EOF

  yay -S waybar-hyprland-git otf-font-awesome ttf-unifont noto-fonts-emoji sysstat libqalculate bc ttf-hack
  cp -r $SCRIPT_DIR/.config/waybar $HOME/.config/

  sudo pacman -S vnstat
  sudo systemctl enable vnstat
}

install_hyprland () {
  cat <<EOF

###################################################
###                                             ###
###             INSTALLING HYPRLAND             ###
###                                             ###
###################################################

EOF

  sudo pacman -S pipewire pipewire-pulse wireplumber grim slurp
  systemctl --user enable pipewire pipewire-pulse wireplumber

  yay -S hyprland xdg-desktop-portal-hyprland-git swaylock-effects swaybg wl-clipboard brightnessctl lxsession xf86-video-amdgpu dunst libnotify qt5-wayland qt6-wayland gnome-themes-extra bibata-cursor-theme swayidle wlrctl-git

  cp -r $SCRIPT_DIR/.config/hypr $SCRIPT_DIR/.config/wallpapers $SCRIPT_DIR/.config/dunst $SCRIPT_DIR/.config/electron-flags.conf $HOME/.config/

  sudo pacman -S go xdg-utils
  go install go.senan.xyz/cliphist@latest
}

install_other_programs () {
  cat <<EOF

###################################################
###                                             ###
###          INSTALLING OTHER PROGRAMS          ###
###                                             ###
###################################################

EOF

  yay -S pavucontrol mpv zathura zathura-pdf-mupdf brave-bin zip unzip bat freetube-bin imagemagick dell-g5se-fanctl iw swayimg
  sudo pacman -S thunderbird
  cp -r $SCRIPT_DIR/.config/zathura $HOME/.config/
}

copy_files_and_create_dirs
install_build_utils
install_yay
install_nodejs
install_misc_dev_stuff
install_neovim
install_et
install_kabmat
install_ranger
install_mpd
install_zsh_and_ohmyzsh
install_kitty
install_hyprland
install_rofi
install_waybar
install_other_programs

cat << EOF
__        __   _                               _                          _
\ \      / /__| | ___ ___  _ __ ___   ___     | |__   ___  _ __ ___   ___| |
 \ \ /\ / / _ \ |/ __/ _ \| '_ \` _ \ / _ \    | '_ \ / _ \| '_ \` _ \ / _ \ |
  \ V  V /  __/ | (_| (_) | | | | | |  __/    | | | | (_) | | | | | |  __/_|
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|    |_| |_|\___/|_| |_| |_|\___(_)
EOF

exit 0
