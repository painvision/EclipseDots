fav_wallpapers_directory="$HOME/.config/hypr/fav_wallpapers"
pin_wallpaper=$(swww query | cut -d: -f6 | xargs)

if [ -e ~/.config/hypr/fav_wallpapers/"$(swww query | cut -d: -f6 | xargs | cut -d/ -f7)" ]
then
    if [[ $(notify-send -t 5000 -i ~/.config/hypr/icons/favourite.png -A "Убрать" "Избранное" "Обои $(swww query | cut -d: -f6 | xargs | cut -d/ -f7) уже в списке избранных!") == "0" ]]; then rm ~/.config/hypr/fav_wallpapers/"$(swww query | cut -d: -f6 | xargs | cut -d/ -f7)"; fi & paplay ~/.config/hypr/sounds/notification.mp3 &
else
    cp "$pin_wallpaper" "$fav_wallpapers_directory"
    if [[ $(notify-send -t 5000 -i ~/.config/hypr/icons/favourite.png -A "Убрать" "Избранное" "Обои $(swww query | cut -d: -f6 | xargs | cut -d/ -f7) добавлены в список избранных") == "0" ]]; then rm ~/.config/hypr/fav_wallpapers/"$(swww query | cut -d: -f6 | xargs | cut -d/ -f7)"; fi & paplay ~/.config/hypr/sounds/notification.mp3 &
fi

