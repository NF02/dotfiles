#!/bin/env sh

opts="Poweroff\nReboot\n"

opts_launch=$(echo "$opts" | rofi -dmenu -i -p "Power menù")

case $opts_launch in
    "Poweroff") poweroff;;
    "reboot") systemctl reboot;;
esac
