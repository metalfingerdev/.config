#!/usr/bin/env bash

# This script verifies that smart_focus.sh successfully changes focus.
# It will open two small terminals, wait, and then trigger your script.

echo "--- Smart Focus Verification Script ---"
echo "[*] Opening two test windows (kitty)..."

# Open two small kitty windows
kitty --title "TEST_WINDOW_1" sh -c "echo I AM WINDOW 1; exec bash" &
sleep 1
kitty --title "TEST_WINDOW_2" sh -c "echo I AM WINDOW 2; exec bash" &
sleep 1

echo "[*] Windows opened. Current active window:"
hyprctl activewindow -j | jq -r '.title'

echo "[*] Waiting 2 seconds, then running your smart_focus.sh..."
sleep 2

# Run the user's script
/home/manju/.config/hypr/scripts/smart_focus.sh

echo "[*] Script executed. New active window:"
hyprctl activewindow -j | jq -r '.title'

echo ""
echo "--- Verification Complete ---"
echo "If the focus moved from Window 2 to Window 1 (or vice versa), the script works!"
echo "Note: This test assumes you have no floating windows currently focused."
