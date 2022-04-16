#!/bin/zsh

export EDITOR="emacs"
export TERMINAL="kitty"
export FM="$TERMINAL -e ranger"
export MP="ncmpcpp"
export PDFR="zathura"

# sys directory
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSSTFILE="-"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"


export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.

