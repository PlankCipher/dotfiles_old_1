#!/bin/bash

if ! pgrep kabmat > /dev/null; then
  kitty --title kabmat kabmat &
  sleep 2
  hyprctl dispatch togglespecialworkspace
  sleep 0.5
  hyprctl dispatch togglespecialworkspace
  killall kabmat

  hyprctl dispatch exec 'kitty --title kabmat kabmat'
  sleep 2
  hyprctl dispatch togglespecialworkspace
  hyprctl dispatch togglespecialworkspace
fi

hyprctl dispatch exec '[workspace 1 silent] kitty'
hyprctl dispatch exec '[workspace 2 silent] kitty'
hyprctl dispatch exec '[workspace 3 silent] brave'
hyprctl dispatch exec '[workspace 5 silent] /opt/FreeTube/freetube --ozone-platform-hint=wayland'
hyprctl dispatch exec '[workspace 7 silent] virt-manager'
hyprctl dispatch exec '[workspace 8 silent] thunderbird'
