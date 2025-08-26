#!/bin/env bash

# --- Check dependencies ----

REQUIRED_PKGS=("git" "stow")

missing=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        missing+=("$pkg")
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "Error: The following required packages are missing: ${missing[*]}"
    echo "Installing..."
    sudo pacman -Syu --needed ${missing[*]}
    exit 1
fi

# - Create folder and clone repo -

mkdir -p ~/dotfiles && cd ~/dotfiles
git clone https://github.com/perletero2/dotfiles.git

# - Stow dotfiles (duh!) -

stow .
echo "Done !"
