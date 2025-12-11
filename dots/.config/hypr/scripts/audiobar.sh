#!/bin/bash
if pgrep -x "cava" > /dev/null
then
    pkill cava & hyprctl notify 6 4000 "rgb(ff0000)" "󰺣  CavaBar OFF (SUPER + SHIFT + A)"
else
    kitty --class cava -c ~/.config/kitty/kitty2.conf cava -p ~/.config/cava/config2 & hyprctl notify 6 4000 "rgb(00ff00)" "󰺢  CavaBar ON (SUPER + SHIFT + A)"
fi
