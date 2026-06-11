#!/usr/bin/env bash
DIR=$1

case "$DIR" in
  u|d)
    hyprctl dispatch togglesplit
    hyprctl dispatch movewindow "$DIR"
    ;;
  l|r)
    hyprctl dispatch movewindow "$DIR"
    ;;
esac