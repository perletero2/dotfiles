#!/bin/env bash

set -euo pipefail

dir="~/dotfiles"

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

# --- Check if repo is already present else retrieve it ---

if [[ ! -d "$dir" ]] ; then
  mkdir -p $dir
fi

cd $dir

updateRepo() {
  local repo_url=$(git config --get remote.origin.url)
  local remote_url="https://github.com/perletero2/dotfiles.git"

  echo "***************************************************************"
  echo "Updating Dotfiles"

  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ] ; then
      echo "Cloning repo..."
      git init
      git remote set-url origin "$remote_url"
      git pull origin main
    
    elif [ "$repo_url" == "$remote_url" ] ; then
      echo "Updating repo..."
      git fetch --all && git stash
      git rebase origin/main
      git stash pop
  
    elif [ "$repo_url" != "$remote_url" ] ; then
      echo "Correcting repo..."
      git remote set-url origin "$remote_url"
      git fetch --all && git stash
      git rebase origin/main
      git stash pop
  fi
}

updateRepo || exit 2

# --- Stow dotfiles (duh!) ---

echo "Stowing files..."
stow . --adopt
echo "Done !"

