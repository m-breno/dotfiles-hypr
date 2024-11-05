#!/usr/bin/env sh

## Variables
config="$HOME/.config/hypr"

# Run as hyprland starts
start() {
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
  # Notifications
  killall mako
  mako -c "$comp/mako/config" &
 
  # Wallpaper
  killall hyprpaper
  hyprpaper &

  # Keyboard backlight
  killall ledToggler.sh
  pkexec "$HOME/.local/bin/ledToggler.sh"
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
