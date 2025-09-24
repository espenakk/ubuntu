#!/usr/bin/env bash
set -euo pipefail

# Only add repo if not already present
if ! dpkg -s eza >/dev/null 2>&1; then
    echo "Adding eza repository and installing eza"
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update -y
    sudo apt-get install -y eza
else
    echo "eza already installed – skipping"
fi
