#!/usr/bin/env bash

wallpapers_dir="$HOME/.config/hypr/wallpapers"

wallpaper=$(find "$wallpapers_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
paplay .config/hypr/sounds/switch_wallpaper.mp3 --volume 25000 &
swww img "$wallpaper" -f Nearest -t any --transition-angle 30 --transition-fps 60 --resize crop & sleep 3;
hellwal -i "$wallpaper" -g 0.4 -b 0.8;
hyprpanel sw "$wallpaper"
# wal -i "$wallpaper" -s -t -e -q -n
# walogram -B -s &
hyprctl reload &
# pywalfox update
cp $(swww query | cut -d: -f6 | xargs) /tmp/lock_screen


