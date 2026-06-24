#!/usr/bin/env bash

# This script cycles focus. If there are floating windows, it prioritize them, 
# otherwise it cycles through tiled windows.

is_floating=$(hyprctl activewindow -j | jq '.floating')

if [ "$is_floating" = "true" ]; then
    # Currently on a floating window, move to next floating or tiled
    hyprctl dispatch cyclenext
else
    # Currently on a tiled window, move to next tiled or floating
    hyprctl dispatch cyclenext
fi