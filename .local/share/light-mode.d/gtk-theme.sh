#!/bin/sh
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" # O il tuo tema chiaro preferito
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
swaymsg output "*" bg ~/Immagini/my-wallpapers/minimal/sway1.png fill
