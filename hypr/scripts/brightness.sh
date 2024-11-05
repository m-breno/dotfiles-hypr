#!/usr/bin/env bash

get() {
  BNESS=$(brillo -Gq)
  export BNESS

  echo "${BNESS%.*}%"
}

get_icon() {
  if [[ ("$BNESS" -ge "0") && ("$BNESS" -le "40") ]]; then
    name="low"
  elif [[ ("$BNESS" -ge "40") && ("$BNESS" -le "75") ]]; then
    name="medium"
  elif [[ ("$BNESS" -ge "75") && ("$BNESS" -le "100") ]]; then
    name="high"
  fi

  icon="/usr/share/icons/Papirus-Dark/24x24/panel/brightness-$name-symbolic.svg"
  export icon
}

notify() {
  get
  #dunstify -u low -h string:x-dunst-stack-tag:obbacklight -i "$icon" "Brightness: $(get_backlight)"
  dunstify -u low -h "int:value:$BNESS" -h string:x-dunst-stack-tag:obbacklight -i "$icon" "Brilho: $(get)"
}

inc() {
  brillo -A 5 -q -u 250000
  notify
}

dec() {
  brillo -U 5 -q -u 250000
  notify
}

case "$1" in
inc) inc ;;
dec) dec ;;
*) get ;;
esac
