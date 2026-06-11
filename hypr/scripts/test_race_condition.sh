#!/usr/bin/env bash

# This script will demonstrate the race condition that causes keys to get stuck
# when Hyprland reloads while keys are held down.

echo "--- Hyprland Keybind Race Condition Tester ---"
echo "Instructions:"
echo "1. Run this script."
echo "2. IMMEDIATELY press and HOLD 'Super' and 'Shift' (but NOT the 'C' key)."
echo "3. The script will wait 2 seconds, then trigger a reload while you are holding them."
echo "4. After the reload finishes, let go of the keys."
echo "----------------------------------------------"

sleep 2

echo "[*] Triggering reload now... HOLD THOSE KEYS!"
hyprctl reload

echo "[*] Reload command sent. You can let go of the keys now."
echo ""
echo "--- Results ---"
echo "Try typing here: "
read -p "> " test_input

echo ""
echo "If your input is empty or looks like you held Super/Shift (e.g. typing 'q' closes the terminal or everything is UPPERCASE),"
echo "then the race condition is confirmed. Your keys are 'stuck' in software."
echo ""
echo "To fix your keyboard without rebooting, physically tap the Super and Shift keys once."
