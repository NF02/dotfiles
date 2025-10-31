#!/bin/bash

# Ottieni la modalità corrente della barra del tablet
# La barra del tablet è 'bar_tablet' (vedi la configurazione sopra)
CURRENT_MODE=$(swaymsg -t get_bar_config bar_tablet | jq -r '.mode')

if [ "$CURRENT_MODE" == "invisible" ]; then
    # PASSAGGIO A MODALITÀ TABLET (Dock ON, Stato OFF)

    # 1. Nascondi la barra di stato normale
    swaymsg bar bar_default mode invisible

    # 2. Mostra la barra dock per il tablet
    swaymsg bar bar_tablet mode dock

    # 3. Altri comandi utili per il tablet (es. rotazione)
    exec rot8 &
    # exec wvkbd & # Avvia la tastiera virtuale

    # 4. tabbed mode
    swaymsg layout tabbed
    
else
    # PASSAGGIO A MODALITÀ LAPTOP (Dock OFF, Stato ON)

    # 1. Mostra la barra di stato normale
    swaymsg bar bar_default mode dock

    # 2. Nascondi la barra dock del tablet
    swaymsg bar bar_tablet mode invisible

    # 3. Ripulisci gli elementi del tablet
    killall rot8
    killall wvkbd-mobintl

    # 4. reload desktop
    # swaymsg reload

    # 5. tiling mode
    swaymsg layout toggle split
fi
