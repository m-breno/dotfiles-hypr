#!/usr/bin/env bash

get() {
  pamixer --get-volume
}

get_human() {
  case "$(pamixer --get-mute)" in
  "true")
    echo "Muted"
    ;;
  *)
    echo "$(get)%"
    ;;
  esac
}

get_icon() {
  if [[ "$(get_human)" == "Muted" ]]; then
    name="muted"
  elif [[ ("$VOL" -ge "0") && ("$VOL" -le "30") ]]; then
    name="low"
  elif [[ ("$VOL" -ge "30") && ("$VOL" -le "70") ]]; then
    name="medium"
  elif [[ ("$VOL" -ge "70") && ("$VOL" -le "100") ]]; then
    name="high"
  fi

  icon="/usr/share/icons/Papirus-Dark/24x24/panel/audio-volume-$name.svg"
  export icon
}

notify() {
  get_icon
  dunstify -u low -h "int:value:$(get)" -h 'string:x-dunst-stack-tag:obvolume' -i "$icon" "Volume: $(get_human)"
}

inc() {
  [[ $(get_human) == "Muted" ]] && pamixer -u
  pamixer -i 5

  notify
}

dec() {
  [[ $(get_human) == "Muted" ]] && pamixer -u
  pamixer -d 5

  notify
}

mute() {
  pamixer -t

  notify
}

case "$1" in
get) get ;;
inc) inc ;;
dec) dec ;;
mute) mute ;;
*) get ;;
esac
