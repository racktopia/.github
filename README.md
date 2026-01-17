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

## Documentation

### 📖 [Pre-commit Setup & Usage](docs/pre-commit.md)
Complete guide to installing, configuring, and using pre-commit hooks with racktopia shared tooling.

### 📖 [Hooks Documentation](docs/hooks.md)
Detailed reference for all available hooks, their purposes, dependencies, and troubleshooting.

## Quick Start

```bash
# 1. Install pre-commit (one-time per machine)
brew install pre-commit

# 2. Install hooks (one-time per repo)
pre-commit install

# 3. Start coding!
# Hooks run automatically and check dependencies as needed
```

## Repository Contents

- **`.markdownlint.json`** - Shared markdown linting rules
- **`.pre-commit-hooks.yaml`** - Hook definitions for other repositories to consume
- **`hooks/`** - Custom hook scripts for complex validation
- **`docs/`** - Comprehensive documentation for setup and usage

## Contributing

When adding new hooks or modifying existing ones:

1. Update hook scripts in `hooks/` directory
2. Update hook definitions in `.pre-commit-hooks.yaml`
3. Update documentation in `docs/hooks.md`
4. Test thoroughly across different repository types
5. Follow the alphabetical ordering convention (except racktopia-standards first)
