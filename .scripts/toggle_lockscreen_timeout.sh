#!/bin/sh

set_timeout () {
  LOCK_TIMEOUT=$1

  swayidle -w \
    timeout $LOCK_TIMEOUT 'swaylock -f -e -F -S -L -K --effect-pixelate 20 --effect-greyscale' \
    timeout $((LOCK_TIMEOUT + 180)) 'hyprctl dispatch dpms off' \
      resume 'hyprctl dispatch dpms on' \
    before-sleep 'swaylock -f -e -F -S -L -K --effect-pixelate 20 --effect-greyscale'
}

toggle_lockscreen_timeout () {
  pgrep swayidle > /dev/null

  # If the previous command exited with a non-zero
  # status, then no swayidle process is running
  if [[ $? -ne 0 ]]; then
    set_timeout 60
  else
    TIMEOUT=$(ps xo args | grep swayidle | grep -v grep | cut -d ' ' -f 4)

    case $TIMEOUT in
      60)
        killall swayidle
        set_timeout 300
        ;;

      300)
        killall swayidle
        set_timeout 600
        ;;

      600)
        killall swayidle
        set_timeout 1800
        ;;

      1800)
        killall swayidle
        ;;
    esac
  fi
}

get_timeout () {
  pgrep swayidle > /dev/null

  if [[ $? -ne 0 ]]; then
    echo '{"text": " Off", "alt": "", "tooltip": "", "class": "off", "percentage": 0}'
  else
    echo '{"text": "'$(echo " $(($(ps xo args | grep swayidle | grep -v grep | cut -d ' ' -f 4) / 60))m")'", "alt": "", "tooltip": "", "class": "", "percentage": 0}'
  fi
}

case $1 in
  toggle)
    toggle_lockscreen_timeout && pkill -SIGRTMIN+9 waybar
    ;;

  *)
    get_timeout
    ;;
esac
