#!/bin/bash
if [ -f ~/.cache/gamemode ] ;then
    hyprctl reload & rm ~/.cache/gamemode & notify-send "Игровой режим" "Включены анимации и режим баланса" & sudo cpufreqctl max set 75
else
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	touch ~/.cache/gamemode & notify-send -i ~/.config/hypr/icons/toggle_on.png "Игровой режим" "Отключены анимации , выставлен режим производительности." & sudo cpufreqctl max set 100
fi

