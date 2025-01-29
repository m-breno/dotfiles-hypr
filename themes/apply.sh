#!/usr/bin/env bash

THEME=$@
THEMEDIR="$XDG_CONFIG_HOME/hypr/themes"

link() {
  # Delete link if exists
  if [[ -L "$THEMEDIR/.current" ]]; then
    rm "$THEMEDIR/.current"
  elif [[ -e "$THEMEDIR/.current" ]]; then #TODO
    echo "Failed to remove symlink. Maybe there's some wrong file/directory in there"
    exit 2
  fi

  # Symlink theme
  ln -sf "$THEMEDIR/$THEME" "$THEMEDIR/.current"
}

reload_kitty() {
  # Reload kitty theme
  kill -SIGUSR1 $(pidof kitty)
}

apply_gtk() {
  # Apply gtk theme
  gsettings set org.gnome.desktop.interface gtk-theme $(cat $THEMEDIR/.current/gtk-theme)
  # Apply icon theme
  gsettings set org.gnome.desktop.interface icon-theme $(cat $THEMEDIR/.current/icon-theme)
}

reload_hyprland() {
  hyprctl reload
}

notify() {
  # Notify
  sleep 1 && notify-send --urgency low "Tema $THEME aplicado" &
}

if [[ -d $THEMEDIR/$THEME ]]; then
  link

  reload_kitty
  apply_gtk
  reload_hyprland

  notify
else
  echo "ERROR: Please provide a valid theme name!"
  echo "Possible names are:"
  eza --color --only-dirs --oneline $THEMEDIR
  exit 1
fi
