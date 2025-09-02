#!/usr/bin/env bash

set -euo pipefail

dir="$HOME/dotfiles"

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
    sudo pacman -S --noconfirm "${missing[@]}" || { echo "Failed to install missing packages"; exit 1; }
fi

# --- Check if repo is already present else retrieve it ---

if [[ ! -d "$dir" ]] ; then
  mkdir -p "$dir" || { echo "Failed to create Dotfiles directory"; exit 1; }
fi

cd "$dir" 

updateRepo() {
  repo_url=$(git config --get remote.origin.url)
  remote_url="https://github.com/perletero2/dotfiles.git"

  echo "***************************************************************"
  echo "Updating Dotfiles"

      # Check if current dir is a git repo, if not create it and pull from source
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]; then 
      echo "Cloning repo..."
      git init || { echo "Failed to initialize git repository in $dir"; exit 1; }
      git remote add origin "$remote_url" || { echo "Failed to set remote url for $dir"; exit 1; }
      git pull origin main || { echo "Failed to pull updates from the remote repo"; exit 1; }
    
      # If it is correct repo, update it.
    elif [ "$repo_url" == "$remote_url" ] ; then 
      echo "Updating repo..."
      git pull origin main || { echo "Failed to pull updates from the remote repo"; exit 1; } 

      # If not, correct the source and update.
    elif [ "$repo_url" != "$remote_url" ] ; then 
      echo "Correcting repo..."
      git remote set-url origin "$remote_url" || { echo "Failed to set remote url for $dir"; exit 1; }
      git fetch --all || { echo "Failed to fetch from source"; exit 1; }
      git stash || { echo "Failed to stash changes"; exit 1; }
      git rebase origin main || { echo "Failed to rebase updates from the remote repo"; exit 1; }
      git stash pop || { echo "Failed to merge local changes"; exit 1; }
  fi
}

updateRepo || { echo "Crappy function, go back to learning you dumbass"; exit 2; }

# --- Stow dotfiles (duh!) ---

echo "Stowing files..."
stow . || { echo "Failed to stow dotfiles"; exit 1; }
echo "Done !"

