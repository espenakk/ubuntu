#!/usr/bin/env bash
set -euo pipefail

# Detect system architecture (arm64 or amd64)
ARCH=$(dpkg --print-architecture)

# Skip if already installed
if dpkg -s fastfetch >/dev/null 2>&1; then
    echo "fastfetch already installed – skipping"
    exit 0
fi

# Find latest release tag
LATEST=$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Download and install the .deb
TMP_DEB="/tmp/fastfetch-${LATEST}_${ARCH}.deb"
echo "Downloading fastfetch $LATEST for $ARCH"
curl -fsSL -o "$TMP_DEB" \
    "https://github.com/fastfetch-cli/fastfetch/releases/download/${LATEST}/fastfetch-linux-${ARCH}.deb"

sudo dpkg -i "$TMP_DEB" || sudo apt-get -f install -y
rm -f "$TMP_DEB"

