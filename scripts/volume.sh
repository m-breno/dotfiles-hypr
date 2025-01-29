#!/usr/bin/env bash

notify() {
  notify-send --urgency low --hint "int:value:$(pamixer --get-volume)" --hint 'string:x-dunst-stack-tag:volume' "Volume: $(pamixer --get-volume-human)"
}

inc() {
  [[ $(pamixer --get-mute) == "true" ]] && pamixer -u
  pamixer --increase 5

  notify
}

dec() {
  [[ $(pamixer --get-mute) == "true" ]] && pamixer -u
  pamixer --decrease 5

  notify
}

mute() {
  pamixer --toggle-mute

  notify
}

case "$1" in
  get) get ;;
  inc) inc ;;
  dec) dec ;;
  mute) mute ;;
  *) echo "get, inc, dec, mute. get:" && get ;;
esac
