#!/usr/bin/env sh

## Variables
config="$HOME/.config/hypr"
comp="$config/components"

# Run as hyprland starts
start() {
  # Notifications
  mako -c "$comp/mako/config" &

  # Wallpaper
  hyprpaper &

  # Keyboard backlight
  "$config/scripts/lightkb.sh"

  # SwayIdle
  "$config/scripts/idle.sh"

  # Other
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

  hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 24 &
  wl-clip-persist --clipboard both &
  /usr/lib/polkit-kde-authentication-agent-1 &

  # Apps
  spotify &
}

# Run at each reload
restart() {

  # waybar
  pkill waybar
  waybar -c "$comp/waybar/config" -s "$comp/waybar/style.css" &
  waybar -c "$comp/waybar/config-mon2" -s "$comp/waybar/style-mon2.css" &
}

case "$1" in
-s)
  start
  ;;
-r)
  restart
  ;;
*)
  printf "Usage: \'-s\' for exec-once and \'-r\' for exec at each reload" && return 1
  ;;
esac
