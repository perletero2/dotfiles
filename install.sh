#!/bin/env bash

set -euo pipefail

# --- Check dependencies ----

REQUIRED_PKGS=("git" "stow")

missing=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        missing+=("$pkg")
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "The following required packages are missing: ${missing[*]}"
    echo "Installing..."
    sudo pacman -S --noconfirm ${missing[*]}
fi

# - Create folder and clone repo -

git clone https://github.com/perletero2/dotfiles.git

# - Stow dotfiles (duh!) -

cd ~/dotfiles
stow .
echo "Done !"

