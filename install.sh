#!/usr/bin/env bash

set -euo pipefail

dir="$HOME/dotfiles"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# --- Check dependencies ----

REQUIRED_PKGS=("git" "stow")

missing=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        missing+=("$pkg")
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${GREEN}The following required packages are missing: ${missing[*]} ${NC}"
    echo -e "${GREEN}Installing...${NC}"
    sudo pacman -S --noconfirm "${missing[@]}" || { echo -e "${RED}Failed to install missing packages${NC}"; exit 1; }
fi

# --- Check if repo is already present else retrieve it ---

if [[ ! -d "$dir" ]] ; then
  mkdir -p "$dir" || { echo -e "${RED}Failed to create Dotfiles directory${NC}"; exit 1; }
fi

cd "$dir" 

updateRepo() {
  repo_url=$(git config --get remote.origin.url)
  remote_url="https://github.com/perletero2/dotfiles.git"

  echo -e "${GREEN}***************************************************************${NC}"
  echo -e "${GREEN}Updating Dotfiles${NC}"

      # Check if current dir is a git repo, if not create it and pull from source
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]; then 
      echo -e "${GREEN}Cloning repo...${NC}"
      git init || { echo -e "${RED}Failed to initialize git repository in $dir ${NC}"; exit 1; }
      git remote add origin "$remote_url" || { echo -e "${RED}Failed to set remote url for $dir ${NC}"; exit 1; }
      git pull origin main || { echo -e "${RED}Failed to pull updates from the remote repo${NC}"; exit 1; }
    
      # If it is correct repo, update it.
    elif [ "$repo_url" == "$remote_url" ] ; then 
      echo -e "${GREEN}Updating repo...${NC}"
      git pull || { echo -e "${RED}Failed to pull updates from the remote repo${NC}"; exit 1; } 

      # If not, correct the source and update.
    elif [ "$repo_url" != "$remote_url" ] ; then 
      echo -e "${GREEN}Correcting repo...${NC}"
      git remote set-url origin "$remote_url" || { echo -e "${RED}Failed to set remote url for $dir ${NC}"; exit 1; }
      git fetch --all || { echo -e "${RED}Failed to fetch from source ${NC}"; exit 1; }
      git stash || { echo -e "${RED}Failed to stash changes ${NC}"; exit 1; }
      git rebase origin main || { echo -e "${RED}Failed to rebase updates from the remote repo${NC}"; exit 1; }
      git stash pop || { echo -e "${RED}Failed to merge local changes${NC}"; exit 1; }
  fi
}

updateRepo || { echo -e "${RED}Crappy function, go back to learning you dumbass${NC}"; exit 2; }

# --- Stow dotfiles (duh!) ---

echo -e "${GREEN}Stowing files...${NC}"
stow . || { echo -e "${RED}Failed to stow dotfiles${NC}"; exit 1; }
echo -e "${GREEN}Done !${NC}"

