#!/usr/bin/env bash

set -euo pipefail

# --- Setting Functions ---

# - Update kitty -

UpdateKitty() {
   KPID=$(pgrep "kitty")
    if [ "$KPID" -ne "0" ]; then
        pkill -USR1 -f /usr/bin/kitty
    fi
}

# - Update RMPC -

UpdateRMPC() {
   RPID=$(pgrep "rmpc")
    if [ "$RPID" -ne "0" ]; then
        rmpc remote set theme ~/.config/rmpc/themes/rmpc.ron
    fi
}

# - Update Cava -

UpdateCava() {
   CPID=$(pgrep "cava")
    if [ "$CPID" -ne "0" ]; then
        pkill -USR2 /usr/bin/cava
    fi
}

  
# --- Execute Functions ---
UpdateKitty
UpdateCava
UpdateRMPC
