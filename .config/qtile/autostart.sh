#!/bin/env zsh
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
mako & 
syncthing --no-browser &
blueman-applet &
conky &

# clip init
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# start wlroots
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

# lock screen
swayidle -w \
          timeout 300 'swaylock \
	--screenshots \
	--clock \
	--indicator \
	--indicator-radius 100 \
	--indicator-thickness 7 \
	--effect-blur 7x5 \
	--effect-vignette 0.5:0.5 \
	--ring-color bb00cc \
	--key-hl-color 880033 \
	--line-color 00000000 \
	--inside-color 00000088 \
	--separator-color 00000000 \
	--grace 2 \
	--fade-in 0.2' \
          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'swaylock \
	--screenshots \
	--clock \
	--indicator \
	--indicator-radius 100 \
	--indicator-thickness 7 \
	--effect-blur 7x5 \
	--effect-vignette 0.5:0.5 \
	--ring-color bb00cc \
	--key-hl-color 880033 \
	--line-color 00000000 \
	--inside-color 00000088 \
	--separator-color 00000000 \
	--grace 2 \
	--fade-in 0.2' &
