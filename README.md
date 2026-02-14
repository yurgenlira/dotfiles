# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) + [Ansible](https://www.ansible.com/) + [Bitwarden CLI](https://bitwarden.com/help/cli/).

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
