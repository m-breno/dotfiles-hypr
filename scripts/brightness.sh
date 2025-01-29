#!/usr/bin/env bash

notify() {
  VALUE=$(brillo -G)
  notify-send --urgency low --hint "int:value:${VALUE%.*}%" --hint 'string:x-dunst-stack-tag:brightness' "Brilho: ${VALUE%.*}%"
}

inc() {
  brillo -A 5 -u 250000

  notify
}

dec() {
  brillo -U 5 -u 250000

  notify
}

case "$1" in
  get) get ;;
  inc) inc ;;
  dec) dec ;;
  *) echo "get, inc, dec.\nget:" && get ;;
esac
