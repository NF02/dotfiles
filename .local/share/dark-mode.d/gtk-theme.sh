#!/bin/sh
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" # O il tuo tema scuro preferito
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
swaymsg output "*" bg ~/Immagini/my-wallpapers/minimal/sway2.png fill
