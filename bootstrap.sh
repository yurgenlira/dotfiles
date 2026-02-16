#!/bin/bash

# bootstrap.sh - Initialize dotfiles environment on Ubuntu

set -euo pipefail

echo "Starting bootstrap process..."

# 0. Ensure not running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Please do not run this script as root/sudo."
    echo "It will ask for your password when needed for package installation."
    exit 1
fi

# 1. Update and install basic dependencies
sudo apt-get update
sudo apt-get install -y curl git age gnupg software-properties-common snapd

# 2. Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
fi

# 3. Install Bitwarden CLI
if ! command -v bw >/dev/null 2>&1 && [ ! -f /snap/bin/bw ]; then
    echo "Installing Bitwarden CLI via snap..."
    sudo snap install bw
fi

# 4. Install chezmoi
if ! command -v chezmoi >/dev/null 2>&1 && [ ! -f /snap/bin/chezmoi ]; then
    echo "Installing chezmoi via snap..."
    sudo snap install chezmoi --classic
fi

# 5. Bitwarden Login & Unlock
if bw status | grep -q '"status":"unauthenticated"'; then
    echo "Logging into Bitwarden..."
    bw login
fi

if bw status | grep -q '"status":"locked"'; then
    echo "Unlocking Bitwarden..."
    BW_SESSION=$(bw unlock --raw)
    export BW_SESSION
    bw sync
fi

# 6. Retrieve or Initialize age key
mkdir -p "$HOME/.config/chezmoi"
if [ ! -f "$HOME/.config/chezmoi/key.txt" ]; then
    echo "Checking for age key in Bitwarden..."
    if bw get notes "chezmoi-age-key" > "$HOME/.config/chezmoi/key.txt" 2>/dev/null; then
        echo "Successfully retrieved age key from Bitwarden."
    else
        echo "Could not find 'chezmoi-age-key' in Bitwarden."
        echo "Generating a new one instead..."
        age-keygen -o "$HOME/.config/chezmoi/key.txt"
        echo "IMPORTANT: Save the following content as a Secure Note named 'chezmoi-age-key' in Bitwarden:"
        cat "$HOME/.config/chezmoi/key.txt"
    fi
fi
sudo chown -R "$(id -u):$(id -g)" "$HOME/.config/chezmoi"
chmod 600 "$HOME/.config/chezmoi/key.txt"

echo "Bootstrap complete. You can now run:"
echo "chezmoi init --apply --branch test/vm-setup <your-github-username>"
