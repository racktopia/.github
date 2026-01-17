# Pre-commit Setup and Usage

This document covers how to set up and use pre-commit hooks with racktopia shared tooling.

## What is Pre-commit?

Pre-commit is a framework for managing git hooks that automatically run checks before commits. It ensures code quality and consistency across all repositories by running linters, formatters, and custom validation tools.

## Quick Setup

### 1. Install Pre-commit (One-time per Machine)

**Using pip:**
```bash
pip install pre-commit
```

**Using Homebrew (macOS/Linux):**
```bash
brew install pre-commit
```

**Using conda:**
```bash
conda install -c conda-forge pre-commit
```

### 2. Install Hooks (One-time per Repository)

```bash
# Navigate to your repository
cd your-repo

# Install the hooks
pre-commit install
```

### 3. Start Coding!

Once installed, hooks run automatically on `git commit`. Dependencies are checked just-in-time with helpful installation instructions if anything is missing.

## Configuration

### Basic Configuration File

Create `.pre-commit-config.yaml` in your repository root:

```yaml
---
repos:
  - repo: https://github.com/racktopia/.github
    rev: main  # or specific commit hash
    hooks:
      - id: racktopia-standards   # Always include this first
      # Keep remaining hooks in alphabetical order:
      - id: ansible-lint          # if you have ansible/ directory
      - id: ansible-syntax-check  # if you have ansible/ directory  
      - id: detect-secrets        # if you have sensitive config files
      - id: markdownlint          # if you have .md files
      - id: yamllint              # if you have .yml/.yaml files
```

**📖 For detailed hook information, see: [Hooks Documentation](hooks.md)**

### Repository-Specific Examples

#### Documentation Repository
```yaml
---
repos:
  - repo: https://github.com/racktopia/.github
    rev: main
    hooks:
      - id: racktopia-standards
      - id: markdownlint
      - id: yamllint
```

#### Ansible Infrastructure Repository
```yaml
---
repos:
  - repo: https://github.com/racktopia/.github
    rev: main
    hooks:
      - id: racktopia-standards
      - id: ansible-lint
      - id: ansible-syntax-check
      - id: detect-secrets
      - id: markdownlint
      - id: yamllint
```

#### racktopia/.github Repository (Special Case)
```yaml
---
repos:
  - repo: https://github.com/racktopia/.github
    rev: main  # Must use 'main' to avoid circular dependency
    hooks:
      - id: racktopia-standards
      - id: detect-secrets
      - id: markdownlint
      - id: yamllint
```

## Daily Usage

### Automatic Execution

Hooks run automatically when you commit:

```bash
git add .
git commit -m "Your commit message"
# Hooks run automatically here
```

### Manual Execution

**Run all hooks on all files:**
```bash
pre-commit run --all-files
```

**Run specific hook on all files:**
```bash
pre-commit run markdownlint --all-files
pre-commit run yamllint --all-files
```

**Run hooks only on staged files:**
```bash
pre-commit run
```

### Bypassing Hooks

Sometimes you need to commit without running hooks:

```bash
git commit --no-verify -m "Emergency fix"
```

**Use sparingly** - bypassing hooks can introduce issues.

## Maintenance

### Updating Hooks

**Check for updates:**
```bash
pre-commit autoupdate
```

**The racktopia-standards hook will fail if hooks are outdated**, ensuring you stay current with the latest shared tooling.

**Review changes before updating:**
```bash
# See commit summaries (commands provided by racktopia-standards hook)
git log --oneline OLD_REV..NEW_REV --no-merges

# See actual code changes
git diff OLD_REV..NEW_REV
```

### Clean Installation

If you encounter issues, reinstall hooks:

```bash
pre-commit uninstall
pre-commit install
```

### Update Hook Cache

If hooks seem outdated after updates:

```bash
pre-commit clean
pre-commit install
```

## Dependency Management

### Just-In-Time Installation

All racktopia hooks use a "just-in-time" dependency approach:

1. **Hook runs** and checks if required tool is installed
2. **If missing**, hook fails with clear installation instructions
3. **Install tool** using the provided command
4. **Re-run commit** - hook passes on subsequent runs

### Common Dependencies

The hooks may require these tools:

```bash
# Markdown linting
npm install -g markdownlint-cli

# YAML linting  
pip install yamllint

# Ansible tools
pip install ansible ansible-lint

# Secret detection
pip install detect-secrets
```

**Don't install everything upfront** - only install tools when hooks request them for your specific repository.

## File Targeting

Hooks automatically run only on relevant files:

- `racktopia-standards` - Always runs (validates configuration)
- `markdownlint` - Only `.md` files
- `yamllint` - Only `.yml/.yaml` files
- `ansible-lint` - Only files under `ansible/` directory
- `ansible-syntax-check` - Only files under `ansible/` directory  
- `detect-secrets` - Only sensitive configuration files

**If no matching files are staged, the hook is skipped.** This allows all repositories to use the same configuration while only running applicable checks.

## Troubleshooting

### Hook Not Running

**Check file patterns:**
```bash
# See what files match hook patterns
pre-commit run --all-files --verbose
```

**Force hook execution:**
```bash
pre-commit run hook-name --all-files
```

### Installation Issues

**Reinstall pre-commit:**
```bash
pip install --upgrade pre-commit
# or
brew upgrade pre-commit
```

**Clear and reinstall hooks:**
```bash
pre-commit clean
pre-commit install --install-hooks
```

### Permission Issues

**Make sure hook scripts are executable:**
```bash
chmod +x .git/hooks/pre-commit
```

### Performance Issues

**Skip hooks for large commits:**
```bash
git commit --no-verify -m "Large refactor"
```

**Run hooks only on changed files:**
```bash
pre-commit run  # instead of --all-files
```

## Advanced Usage

### Custom Hook Configuration

You can add additional hooks alongside racktopia hooks:

```yaml
repos:
  - repo: https://github.com/racktopia/.github
    rev: main
    hooks:
      - id: racktopia-standards
      - id: markdownlint
      - id: yamllint
      
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

### Hook-Specific Configuration

Some hooks can be configured with additional arguments:

```yaml
- id: markdownlint
  args: ['--config', '.markdownlint.custom.json']
```

### CI/CD Integration

Pre-commit works great in CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Run pre-commit hooks
  uses: pre-commit/action@v3.0.1
```

## Best Practices

1. **Always include `racktopia-standards` first** - ensures configuration compliance
2. **Keep hooks in alphabetical order** (except racktopia-standards)
3. **Only include relevant hooks** - based on file types in your repository  
4. **Review changes** when updating hook revisions
5. **Test locally** before pushing configuration changes
6. **Don't bypass hooks** unless absolutely necessary
7. **Install dependencies** as requested rather than proactively
8. **Keep configurations consistent** across similar repositories

## Getting Help

- **Hook-specific issues:** See [Hooks Documentation](hooks.md)
- **Configuration validation:** The `racktopia-standards` hook provides detailed guidance
- **Pre-commit framework:** [Official documentation](https://pre-commit.com/)
- **Tool-specific help:** Each tool provides `--help` flag for detailed options

## Migration from Legacy Systems

If migrating from older validation scripts:

1. **Remove old validation scripts** (like `scripts/setup.sh`)
2. **Create `.pre-commit-config.yaml`** with racktopia hooks
3. **Install pre-commit** and hooks
4. **Test thoroughly** with `pre-commit run --all-files`
5. **Update CI/CD** to use pre-commit instead of custom scripts
6. **Document changes** for team members