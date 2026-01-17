# Racktopia Shared Development Tools

This repository contains shared pre-commit hooks, setup scripts, and development tools used across all Racktopia projects.

## Pre-commit Hooks

### Available Hooks

- **`markdownlint`** - Lint markdown files for consistency and best practices
- **`yamllint`** - Validate YAML syntax and formatting  
- **`ansible-lint`** - Check Ansible playbooks and roles for best practices
- **`ansible-syntax-check`** - Validate Ansible playbook syntax
- **`detect-secrets`** - Scan for accidentally committed secrets

### Usage

Add this to your repository's `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/racktopia/.github
    rev: main
    hooks:
      - id: markdownlint
      - id: yamllint  
      - id: ansible-lint
      - id: ansible-syntax-check
      - id: detect-secrets
```

### Installation

```bash
# Install pre-commit (one-time per machine)
pip install pre-commit
# or: brew install pre-commit

# Install hooks (one-time per repo)  
pre-commit install

# Run manually
pre-commit run --all-files
```

### Hook Behavior

Hooks automatically run only on relevant files:

- `markdownlint` runs only on `.md` files
- `yamllint` runs only on `.yml/.yaml` files  
- `ansible-lint` runs only on files under `ansible/` directory
- If no matching files are staged, the hook is skipped

This allows all repositories to use the same configuration while only running applicable checks.

## Configuration Files

- **`.markdownlint.json`** - Shared markdown linting rules
- **`.pre-commit-hooks.yaml`** - Hook definitions for other repositories to consume
- **`hooks/`** - Custom hook scripts for complex validation

## Local Development

After installing pre-commit hooks, they run automatically on `git commit`. To bypass:

```bash
git commit --no-verify
```

To run specific hooks:

```bash
pre-commit run markdownlint --all-files
```

To update hook versions:

```bash
pre-commit autoupdate
```

## Shared Setup Scripts

### setup-base.sh

A parameterized setup script that handles common development environment setup across different project types.

**Usage in your repositories:**

```bash
# In your repo's scripts/setup.sh
curl -sSL https://raw.githubusercontent.com/racktopia/.github/main/scripts/setup-base.sh | bash -s <project_type>
```

**Available project types:**

- `ansible` - Installs Ansible, Galaxy requirements, sets up pre-commit
- `python` - Installs Python dependencies, sets up pre-commit  
- `node` - Installs npm dependencies, sets up pre-commit
- `generic` - Basic setup with pre-commit only

**Features:**

- Python version checking
- Pre-commit installation and hook setup
- Project-specific dependency installation
- Interactive pre-commit hook installation
- Cross-platform support (Homebrew/MacPorts)
