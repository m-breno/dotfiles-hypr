#!/usr/bin/env bash

iDIR='/usr/share/icons/Papirus-Dark/24x24/actions/'

get_volume() {
  get="$(pamixer --get-volume)"
  case "$get" in
  0) echo "Muted" ;;
  *) echo "$get" ;;
  esac
}

get_icon() {
  current="$(get_volume)"
  if [[ "$current" -eq "0" ]]; then
    icon="$iDIR/volume-mute.png"
  elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
    icon="$iDIR/volume-low.png"
  elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
    icon="$iDIR/volume-mid.png"
  elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
    icon="$iDIR/volume-high.png"
  fi
}

notify() {
  get_volume_human() {
    case "$(get_volume)" in
    "Muted")
      echo Muted
      ;;
    *)
      echo $(get_volume)%
      ;;
    esac

  }
  dunstify -u low -h 'string:x-dunst-stack-tag:obvolume' -i "$icon" "Volume: $(get_volume_human)"
}

inc_volume() {
  [[ $(pamixer --get-mute) == true ]] && pamixer -u
  pamixer -i 5
  get_icon
  notify
}

dec_volume() {
  [[ $(pamixer --get-mute) == true ]] && pamixer -u
  pamixer -d 5
  get_icon
  notify
}

mute() {
  pamixer -t
  get_icon
  notify
}

case "$1" in
-g | --get) get_volume ;;
-i | --inc) inc_volume ;;
-d | --dec) dec_volume ;;
-t | -m | --toggle | --mute) mute ;;
*) echo $(get_volume) ;;
esac
