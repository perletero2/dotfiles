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

# - Update Cava -

UpdateCava() {
   CPID=$(pgrep "cava")
    if [ "$CPID" -ne "0" ]; then
        pkill -USR2 /usr/bin/cava
    fi
}


# - Update Firefox with Pywalfox -
UpdateFirefox() {
  pywalfox update
}

# --- Execute Functions ---
UpdateKitty
UpdateCava
#UpdateFirefox # Not needed if messager installed
