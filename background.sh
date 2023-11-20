#!/usr/bin/env bash

WALLPAPER_DIR="$1"

select_random_wallpaper() {
    FIND=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.svg" -o -iname "*.gif" \) -print)
    COUNT=$(echo "$FIND" | wc -l)
    if [ "$COUNT" -le 1 ]; then
        echo "You need at least 2 images in the target folder"
        exit
    fi
    WALLPAPER=$(echo "$FIND" | shuf -n 1)
    echo $WALLPAPER
}

gnome() {
    CURRENT_WALLPAPER=$(gsettings get org.gnome.desktop.background picture-uri)
    select_random_wallpaper
    while [ "'file://$WALLPAPER'" = $CURRENT_WALLPAPER ]; do
        select_random_wallpaper
    done

    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
}

GNOME=false
KITTY=false

while :; do
    case "${2}" in
        -g | --gnome)
            GNOME=true
            shift
            ;;
        -- | '')
            shift
            break
            ;;
        *)
            echo default
            ;;
    esac
done

if [ "$GNOME" = true ]; then
    gnome
fi

