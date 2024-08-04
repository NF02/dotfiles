#!/bin/env zsh
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
mako & 
syncthing --no-browser &
blueman-applet &

# clip init
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
