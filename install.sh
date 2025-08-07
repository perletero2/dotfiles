#!/bin/env bash

# - Create folder and clone repo -
mkdir -p ~/dotfiles
cd ~/dotfiles

git clone https://github.com/perletero2/dotfiles.git

# - Check if Stow is installed -

is_installed() {
    pacman -Qk $1 &> /dev/null
}

package_name="stow"

 if ! is_installed $package_name; then
       echo "Installing $package_name ..."
       sudo pacman -S stow   
    else 
      echo "$package_name is installed"
 fi

# - Stow dotfiles (duh!) -

stow .

