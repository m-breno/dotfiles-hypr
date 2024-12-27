#!/usr/bin/env sh
swayidle -w \
  before-sleep "playerctl pause" \
  timeout 120 "hyprctl dispatch dpms off" resume "hyprctl dispatch dpms on" \
  timeout 135 "$XDG_CONFIG_HOME/hypr/scripts/lock.sh" \
  timeout 300 "systemctl suspend"
