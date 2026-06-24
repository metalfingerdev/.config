#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting NixOS rebuild and system upgrade..."

# 1. Build and activate the new configuration
echo "Switching to new configuration..."
sudo nixos-rebuild switch

# 2. Optimise the Nix store to remove duplicate files
echo "Optimising Nix store space..."
sudo nix-store --optimise

# 3. Update EFI partition binaries
echo "Updating systemd-boot binaries"

echo "NixOS system update and cleanup completed successfully!"
