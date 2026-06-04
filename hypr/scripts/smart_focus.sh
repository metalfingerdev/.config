#!/usr/bin/env bash

is_floating=$(hyprctl activewindow -j | jq '.floating')

if [ "$is_floating" = "true" ]; then
    hyprctl dispatch cyclenext tiled
else
    hyprctl dispatch cyclenext floating
fi
