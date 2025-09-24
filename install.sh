#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/espenakk/ubuntu.git"
CLONE_DIR="$HOME/.ubuntu"
PKG_FILE="packages.txt"

log() { printf "\n\033[1;32m==> %s\033[0m\n" "$1"; }

# --- 1. Clone or update repo ---
if [ ! -d "$CLONE_DIR/.git" ]; then
    log "Cloning bootstrap repo with submodules"
    git clone --depth=1 --recurse-submodules "$REPO_URL" "$CLONE_DIR"
else
    log "Updating bootstrap repo"
    git -C "$CLONE_DIR" pull --ff-only
    git -C "$CLONE_DIR" submodule update --init --recursive
fi

# --- 2. Install apt packages ---
log "Installing apt packages"
mapfile -t pkgs < <(
    grep -v '^#' "$CLONE_DIR/$PKG_FILE" | grep -v '^CUSTOM:' | grep -v '^POST:'
)

if [ "${#pkgs[@]}" -gt 0 ]; then
    sudo apt-get update -y
    sudo apt-get install -y "${pkgs[@]}"
fi

# --- 3. Run custom installers ---
log "Running custom installers"
while IFS= read -r line; do
    [[ $line =~ ^CUSTOM: ]] || continue
    installer=${line#CUSTOM:}
    log "-> $installer"
    case "$installer" in
        eza)
            bash "$CLONE_DIR/custom-installers/eza.sh"
            ;;
	fastfetch)
            bash "$CLONE_DIR/custom-installers/fastfetch.sh"
            ;;
        *)
            # fallback for inline commands
            eval "$installer"
            ;;
    esac
done < "$CLONE_DIR/$PKG_FILE"


# --- 4. Deploy dotfiles with GNU Stow ---
log "Stowing dotfiles"
cd "$CLONE_DIR/config"
stow --target="$HOME" */

# --- 5. Optional tweaks ---
log "Running postinstall"
bash "$CLONE_DIR/postinstall.sh" || true

log "Bootstrap complete!"

