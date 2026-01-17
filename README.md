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

### Hook Documentation

For detailed information about all available hooks, configuration options, and troubleshooting, see:

**📖 [Hooks Documentation](docs/hooks.md)**

### Quick Reference

Hooks automatically run only on relevant files:

- `racktopia-standards` - Enforces configuration compliance (always runs)
- `markdownlint` - Runs only on `.md` files
- `yamllint` - Runs only on `.yml/.yaml` files  
- `ansible-lint` + `ansible-syntax-check` - Run only on files under `ansible/` directory
- `detect-secrets` - Runs on sensitive configuration files

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

## Getting Started

New to a racktopia repository? Here's all you need:

```bash
# 1. Install pre-commit (one-time per machine)
brew install pre-commit

# 2. Install hooks (one-time per repo)
pre-commit install

# 3. Start coding!
# Pre-commit hooks check dependencies as needed and provide helpful install instructions
```

The hooks will automatically check for required tools when you edit relevant files and give
you clear install instructions if anything is missing.
