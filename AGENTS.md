# AI Agents Working Guidelines for This Project

Welcome, AI Agent! When you are assigned tasks on this `dotfiles` project, please strictly adhere to the following guidelines to ensure consistency, scalability, and maintainability.

## 1. Project Architecture (Ansible)
This repository uses a **Data-Driven Ansible setup**. 
Do **NOT** create a new Ansible role for every new application. Instead, use the centrally managed lists in `ansible/group_vars/all.yml` and the universal `common` role.

### How to add new software:
1. Open `ansible/group_vars/all.yml`.
2. If the software requires a custom APT repository, add it to the `external_repositories` list. Remember to define the `key_url`, `repo` string, and `keyring` destination. The `common` role will automatically download the GPG key, de-armor it, and configure the apt source.
3. Add the package name to the `workstation_packages` list. 

*Exceptions: Only create dedicated roles for software that requires complex configuration files, multi-step templating, or entirely different package managers (e.g., Snap, Flatpak) that cannot be handled by standard definitions.*

## 2. Secrets Management
- We use **Bitwarden CLI** (`bw`) and **`age`** encryption via `chezmoi`.
- **Never** commit unencrypted sensitive information, API keys, or private SSH keys.
- **SSH Keys:** Read from Bitwarden Secure Notes via explicit `run_once_` scripts, or pulled via normal `bitwarden` chezmoi templates.
- If you need to add encrypted files to the repo, rely on `chezmoi add --encrypt <file>`.

## 3. Tool Calling Conventions
When modifying files:
1. Always prefer the most precise editing tools available (`replace_file_content` or `multi_replace_file_content`). Ensure you define exact `StartLine` and `EndLine` for safe patches.
2. Avoid `run_command` with `echo "text" >> file` or `sed`. Use native replacement tools.
3. Don't build separate workflows if `chezmoi apply` or `ansible-playbook` already covers the domain.

## 4. Local Testing & Linting
- Ensure you update `tests/test-packages.sh` whenever you add a new binary or package to `group_vars/all.yml`.
- Before suggesting massive Ansible changes, ensure they pass `ansible-lint`. You can run `ansible-lint` by activating the `.venv` in the repository root (e.g., `source .venv/bin/activate && ansible-lint ansible/site.yml`).
- **Ansible Lint Rules to Remember:**
  - **Pipes in Shell tasks (`risky-shell-pipe`)**: Whenever using a pipe `|` in an `ansible.builtin.shell` task, you must prepend it with `set -o pipefail` and specify `executable: /bin/bash`.
  - **YAML Truthy values (`yaml[truthy]`)**: Always use standard YAML booleans `true` or `false` (lowercase). Do not use `yes` or `no`.
  - **Dependencies**: Custom modules (like `community.general.dconf`) require their collections to be installed (`ansible-galaxy collection install -r ansible/requirements.yml`) before linting will pass.
- Integration tests are available via `bash tests/run-all.sh`.

## 5. Idempotence
Scripts must be strictly idempotent:
- Ansible tasks are idempotent by design. Follow best practices.
- If writing a `run_once_` script for chezmoi, use standard bash guard clauses (`if ! command -v tool; then ... fi` or checking for file existence).

Thank you for helping maintain a clean, scalable, and secure dotfiles environment!
