# Dotfiles

> Managed with [chezmoi](https://www.chezmoi.io/) + [Ansible](https://www.ansible.com/) + [Bitwarden CLI](https://bitwarden.com/help/cli/).
> Portable across standard Linux distributions and WSL, with support for hybrid work/personal environments.

![CI](https://github.com/yurgenlira/dotfiles/actions/workflows/ci.yml/badge.svg)

---

## ⚡ Quick Start

On a fresh machine, install `curl` and run the bootstrap script:

```bash
sudo apt update && sudo apt install -y curl
bash -c "$(curl -fsLS https://raw.githubusercontent.com/yurgenlira/dotfiles/main/bootstrap.sh)"
```

Then initialize and apply your dotfiles:

```bash
chezmoi init --apply yurgenlira
```

The bootstrap script will:
1. Install all dependencies (`ansible`, `age`, `bw`, `chezmoi`)
2. Log you into Bitwarden and unlock your vault
3. Retrieve (or generate) your `age` encryption key
4. Prompt you to run `chezmoi init --apply`

---

## 🤖 What is Automated?

### 🛠️ System Configuration (via Ansible)
- **Data-Driven Installation**: Software is managed via `ansible/group_vars/all.yml` for easy scaling.
- **Base & Workstation Packages**: `antigravity`, `curl`, `git`, google-chrome`, `htop`, `jq`, `terraform`, and more.
- **System Hardening**: Configures passwordless `sudo` for the current user.
- **Desktop Environment (GNOME)**:
  - Dark mode preference.
  - Custom clock (show date, hide seconds).
  - Power management (disable sleep on AC).

### 🔐 Secrets & Identity (via Bitwarden + age)
- **SSH Keys**: Provisioned from Bitwarden Secure Notes into `~/.ssh/`.
- **AWS Credentials**: Fetched per-environment from Bitwarden using your work email.
- **Encryption**: Sensitive files (e.g. `~/.ssh/config`) are encrypted with `age` in the repo.
- **Key Management**: `age` key is retrieved from Bitwarden on init, or generated and backed up automatically.

### 🐚 Shell Environment (via chezmoi)
- **Aliases & Functions**: Custom bash helpers and Bitwarden session management.
- **Git Config**: Conditional identities for personal and work repositories.
- **Editor Integration**: `chezmoi edit`, `diff`, and `merge` configured for VS Code.

---

## 🗂️ Repository Structure

```
dotfiles/
├── ansible/
│   ├── group_vars/
│   │   └── all.yml       # Centralized package and repo lists (Scalable!)
│   ├── roles/
│   │   ├── common/       # Generic installer (Engine)
│   │   └── gnome/        # GNOME desktop settings
│   ├── site.yml          # Main playbook
│   ├── ansible.cfg
│   └── requirements.yml
├── tests/
│   ├── fixtures/
│   │   └── bw-data.json  # Fake Bitwarden vault for CI testing
│   ├── mocks/
│   │   └── bw            # Mock Bitwarden CLI binary
│   ├── run-all.sh        # Test runner
│   ├── test-dotfiles.sh  # Assert dotfiles were applied
│   ├── test-packages.sh  # Assert packages are installed
│   └── test-age-key.sh   # Assert age key setup
├── private_dot_ssh/      # SSH config and keys (age-encrypted)
├── dot_aws/              # AWS config and credentials (Bitwarden-sourced)
├── .chezmoi.toml.tmpl    # chezmoi config with prompts and encryption
├── bootstrap.sh          # One-shot setup script
└── run_once_after_ansible.sh.tmpl
```

---

## 🔐 Secrets & Encryption

| Secret | Storage | How it's used |
|---|---|---|
| SSH private key | Bitwarden Secure Note | Pulled via `bitwarden` template function |
| AWS credentials | Bitwarden Custom Fields | Pulled via `bitwardenFields` template function |
| `age` private key | Bitwarden Secure Note | Retrieved during bootstrap, stored at `~/.config/chezmoi/key.txt` |
| Encrypted files | Git repo (`.age`) | Decrypted by chezmoi using the `age` identity |

---

## 🧪 Testing & Development

### Local Tests
Run the integration tests locally:
```bash
bash tests/run-all.sh
```

Tests verify:
- ✅ Dotfiles are applied (`~/.bash_aliases`, `~/.gitconfig`, etc.)
- ✅ Required packages are installed
- ✅ `age` key exists with correct `600` permissions

### Ansible Linting
For local Ansible development, we use `ansible-dev-tools`.
```bash
# Setup 
python3 -m venv .venv
source .venv/bin/activate
pip install ansible-dev-tools

# Run linting
ansible-lint ansible/site.yml
```

CI runs automatically on every push and pull request via GitHub Actions.
