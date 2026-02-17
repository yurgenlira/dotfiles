# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) + [Ansible](https://www.ansible.com/) + [Bitwarden CLI](https://bitwarden.com/help/cli/). 
It is designed to be portable across standard Linux distributions and Windows Subsystem for Linux (WSL), with specialized support for hybrid work/personal environments.

## What is Automated?

### 🛠️ System Configuration (via Ansible)
- **Base Packages**: `curl`, `git`, `htop`, `jq`, `python3-psutil`.
- **System Hardening**: Configures passwordless `sudo` for the current user.
- **Desktop Environment (GNOME)**:
    - Dark mode preference.
    - Custom clock (show date, hide seconds).
    - Power management (disable sleep on AC).
- **Software Installation**:
    - [Google Chrome](https://www.google.com/chrome/)
    - [Antigravity](https://antigravity.dev/) (Self-updating agent)
    - [Bitwarden CLI](https://bitwarden.com/help/cli/)
    - [chezmoi](https://www.chezmoi.io/)

### 🔐 Secrets & Identity (via Bitwarden + age)
- **SSH Keys**: Provisioned directly from Bitwarden Secure Notes into `~/.ssh/`.
- **AWS Credentials**: Managed per-environment (Work/Personal) and pulled from Bitwarden.
- **Encryption**: Files like `.ssh/config` are safely encrypted in the repo using `age`.
- **Key Management**: `age` keys are automatically retrieved from or backed up to Bitwarden during bootstrap.

### 🐚 Shell Environment (via chezmoi)
- **Aliases & Functions**: Custom bash helpers and Bitwarden session management.
- **Git Config**: Conditional identities for personal and work-related repositories.

## Bootstrap

To set up a new machine, first ensure `curl` is installed:

```bash
sudo apt update && sudo apt install -y curl
```

Then run:

```bash
bash -c "$(curl -fsLS https://raw.githubusercontent.com/yurgenlira/dotfiles/main/bootstrap.sh)"
```

Then initialize chezmoi:

```bash
chezmoi init --apply yurgenlira
```

## Structure

- `bootstrap.sh`: Installs system dependencies (Ubuntu).
- `ansible/`: Playbooks for system-level configuration.
- `dot_chezmoi.toml.tmpl`: Configuration for encryption and secrets.
- `run_once_after_ansible.sh.tmpl`: Trigger for Ansible playbooks.

## Secrets & Encryption

- Secrets are managed via Bitwarden CLI.
- Sensitive files are encrypted using `age`.
- The `age` key is stored at `~/.config/chezmoi/key.txt`.
