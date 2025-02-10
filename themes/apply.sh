#!/usr/bin/env bash

THEME=$@
THEMEDIR="$XDG_CONFIG_HOME/hypr/themes"

echo -e "Applying \033[1m$THEME\033[0m theme..."

link() {
  # Delete link if exists
  echo "  Removing current link..."

  if [[ -L "$THEMEDIR/.current" ]]; then
    rm "$THEMEDIR/.current"
  elif [[ -e "$THEMEDIR/.current" ]]; then
    echo -e "  \033[31;1mERROR: \033[0;31mFailed to remove symlink.\033[0m"
    echo "  Maybe there's some wrong file/directory in there:"
    echo "$THEMEDIR"
    echo -e "  \033[1mManual intervention needed.\033[0m"

    exit 2
  fi

  # Symlink theme
  echo "  Symlinking current theme..."
  ln -sf "$THEMEDIR/$THEME" "$THEMEDIR/.current"
}

reload_kitty() {
  # Reload kitty theme
  echo "  Reloading Kitty theme..."

  kill -SIGUSR1 $(pidof kitty)
}

apply_gtk() {
  # Apply gtk theme
  echo "  Applying GTK theme..."

  gsettings set org.gnome.desktop.interface gtk-theme $(cat $THEMEDIR/.current/gtk-theme)

  # Apply icon theme
  echo "  Applying icon theme..."

  gsettings set org.gnome.desktop.interface icon-theme $(cat $THEMEDIR/.current/icon-theme)
}

reload_hyprland() {
  # Reload hyprland config
  echo "  Reloading Hyprland..."

  hyprctl reload > /dev/null
}

notify() {
  # Notify
  echo -e "\033[1m$THEME\033[0m theme applied successfully."

  notify-send --urgency low "Tema $THEME aplicado" &
}

if [[ -d $THEMEDIR/$THEME ]]; then
  link

  reload_kitty
  apply_gtk
  reload_hyprland

  notify
else
  echo -e "  \033[31;1mERROR: \033[0;31mPlease provide a valid theme name!\033[0m"
  echo "  Possible names are:"
  eza --color --only-dirs --oneline $THEMEDIR

  exit 1
fi
