#!/bin/bash

VERT_FILE="$HOME/.vert"
STYLE_CONF="$HOME/.config/hypr/style.conf"

# Проверяем параметр
case "$1" in
    --horizontal)
        # Если файл существует → удалить + sed
        if [ -f "$VERT_FILE" ]; then
            rm -f "$VERT_FILE"
            sed -i 's/slidevert/slide/g' "$STYLE_CONF"
        fi
        ;;

    --vertical)
        # Если файла не существует → создать + sed
        if [ ! -f "$VERT_FILE" ]; then
            touch "$VERT_FILE"
            sed -i 's/slide/slidevert/g' "$STYLE_CONF"
        fi
        ;;

    *)
        echo "Использование: $0 --horizontal | --vertical"
        exit 1
        ;;
esac
