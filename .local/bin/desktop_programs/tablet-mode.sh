#!/bin/bash

# Controlli iniziali
BAR_DEFAULT_ID="bar_default"
BAR_TABLET_ID="bar_tablet"

# Funzione per interrogare lo stato della barra del tablet
CURRENT_MODE=$(swaymsg -t get_bar_config "$BAR_TABLET_ID" | jq -r '.mode')

if [ "$CURRENT_MODE" == "invisible" ]; then
    echo "Attivazione Modalità Tablet..."

    # PASSAGGIO A MODALITÀ TABLET (Dock ON)

    # 1. Barre
    swaymsg bar "$BAR_DEFAULT_ID" mode invisible
    swaymsg bar "$BAR_TABLET_ID" mode dock

    # 2. Layout
    swaymsg layout tabbed

    # 3. Processi in background
    pgrep rot8 || rot8 &
        
    echo "Modalità Tablet Attivata."
    
else
    echo "Attivazione Modalità Laptop..."

    # PASSAGGIO A MODALITÀ LAPTOP (Dock OFF)

    # 1. Barre
    swaymsg bar "$BAR_DEFAULT_ID" mode dock
    swaymsg bar "$BAR_TABLET_ID" mode invisible

    # 2. Processi in background (Pulisci solo se in esecuzione)
    killall -q rot8
    killall -q wvkbd-mobintl

    # 3. Layout (ripristina il layout tiling standard)
    # Si assume che "split" sia il default per i laptop.
    swaymsg layout split 
    
    echo "Modalità Laptop Attivata."
fi
