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

# 5. Bitwarden Login
if ! bw status | grep -q "authenticated"; then
    echo "Logging into Bitwarden..."
    bw login
fi

# 6. Initialize age key if not present
if [ ! -f "$HOME/.config/chezmoi/key.txt" ]; then
    echo "Generating age key..."
    mkdir -p "$HOME/.config/chezmoi"
    age-keygen -o "$HOME/.config/chezmoi/key.txt"
    echo "IMPORTANT: Save the following public key to your Bitwarden vault:"
    age-keygen -y "$HOME/.config/chezmoi/key.txt"
fi

echo "Bootstrap complete. You can now run:"
echo "chezmoi init --apply --branch test/vm-setup <your-github-username>"
