# Pre-commit Hooks Documentation

This document describes all the shared pre-commit hooks available in the racktopia organization.

## Available Hooks

### racktopia-standards

**Purpose:** Enforces consistent pre-commit configuration across all racktopia repositories.

**What it checks:**

- Verifies `.pre-commit-config.yaml` exists and uses racktopia/.github hooks
- Ensures appropriate hooks are enabled based on file types present:
  - `markdownlint` for repositories with `.md` files
  - `yamllint` for repositories with `.yml/.yaml` files
  - `ansible-lint` + `ansible-syntax-check` for Ansible projects
  - `detect-secrets` for projects with sensitive configuration files
- Validates that hook revisions are up-to-date using configurable freshness limits

**Freshness checking:**

- Uses dual criteria: hooks pass if within **EITHER** commit limit OR time limit (not both required)
- Default limits: 10 commits behind OR 7 days old
- Shows detailed progress: `✅ racktopia/.github hooks are current (51798d7, 1/10 commits behind, 0:00 old)`
- Early warnings when approaching limits (>5 commits behind OR >3 days old)
- All limits are user-configurable via variables at the top of the hook file

**Configuration variables (in hook file):**

```bash
MAX_COMMITS_BEHIND=10     # Maximum commits behind before requiring update
MAX_DAYS_OLD=7            # Maximum days old before requiring update  
WARNING_COMMIT_THRESHOLD=5 # Early warning threshold (commits)
WARNING_DAY_THRESHOLD=3    # Early warning threshold (days)
```

**Special handling:**

- For `racktopia/.github` repository itself: Must use `rev: main` to avoid circular dependency
- For other repositories: Uses GitHub API to check commit freshness with detailed progress indicators
- Fails only if hooks are both >N commits behind AND >N days old (dual criteria)
- Provides helpful commands to review changes and update when outdated
- Shows warnings when approaching configured limits

**When it runs:** Always (not file-specific)

---

### markdownlint

**Purpose:** Ensures consistent markdown formatting and style.

**What it checks:**

- Line length limits (120 characters by default)
- Proper heading structure
- Consistent list formatting
- Link formatting
- Code block syntax

**Configuration:** Uses shared `.markdownlint.json` in racktopia/.github

**When it runs:** Only on `.md` files

**Dependencies:** Requires `markdownlint-cli` (installed via npm)

---

### yamllint

**Purpose:** Validates YAML syntax and formatting.

**What it checks:**

- Valid YAML syntax
- Consistent indentation
- Document start markers (`---`)
- Trailing whitespace
- Proper line endings

**When it runs:** Only on `.yml/.yaml` files

**Dependencies:** Requires `yamllint` (installed via pip)

---

### ansible-lint

**Purpose:** Lints Ansible playbooks, roles, and tasks for best practices.

**What it checks:**

- Ansible best practices
- Task naming conventions
- Proper use of modules
- Variable naming
- Security considerations

**When it runs:** Only on Ansible files (files under `ansible/` directory)

**Dependencies:** Requires `ansible-lint` (installed via pip)

---

### ansible-syntax-check

**Purpose:** Validates Ansible playbook syntax.

**What it checks:**

- YAML syntax specific to Ansible
- Valid Ansible module usage
- Proper task structure
- Variable references

**When it runs:** Only on Ansible files (files under `ansible/` directory)

**Dependencies:** Requires `ansible` (installed via pip)

---

### detect-secrets

**Purpose:** Prevents accidental commit of secrets and sensitive information.

**What it checks:**

- API keys and tokens
- Passwords and credentials
- Private keys
- Database connection strings
- Other sensitive patterns

**When it runs:** On relevant files (Ansible configs, environment files, GitHub workflows)

**Dependencies:** Requires `detect-secrets` (installed via pip)

## Hook Configuration

### Basic Configuration

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

### Repository-Specific Rules

#### racktopia/.github Repository

- Must use `rev: main` to avoid circular dependency
- Should include `racktopia-standards`, `markdownlint`, `yamllint`, and `detect-secrets`

#### Ansible Projects (like manifest-destiny)

- Should include all hooks: `racktopia-standards`, `markdownlint`, `yamllint`, `ansible-lint`,
  `ansible-syntax-check`, `detect-secrets`

#### Documentation-Only Repositories

- Typically need: `racktopia-standards`, `markdownlint`, `yamllint`

## Dependency Management

### Just-In-Time Installation

All hooks use a "just-in-time" dependency checking approach:

1. Hook runs and checks if required tool is installed
2. If tool is missing, hook fails with clear installation instructions
3. User installs the tool using the provided command
4. Hook passes on subsequent runs

### Common Installation Commands

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

## Maintenance

### Updating Hook Revisions

**Check for updates:**

```bash
pre-commit autoupdate
```

**Review changes before updating:**

```bash
# See commit summaries
git log --oneline OLD_REV..NEW_REV --no-merges

# See actual code changes  
git diff OLD_REV..NEW_REV
```

**The racktopia-standards hook will fail if hooks are both outdated (beyond configured limits)** and provide detailed
progress information, ensuring all repositories stay current with the latest shared tooling. The hook shows:

- Current position: `3/10 commits behind, 2 days, 14:32 old`
- Early warnings: `⚠️ WARNING: Approaching update limits!`
- Helpful update commands when limits are exceeded

### Adding New Hooks

1. Create hook script in `hooks/` directory
2. Make script executable: `chmod +x hooks/new-hook`
3. Add hook definition to `.pre-commit-hooks.yaml`
4. Update this documentation
5. Test thoroughly before releasing

### Best Practices

1. **Always include `racktopia-standards` first** - ensures configuration compliance
2. **Keep hooks in alphabetical order** (except racktopia-standards)
3. **Only include hooks relevant to your project** - based on file types present
4. **Pin to specific commit hashes** for reproducibility (except racktopia/.github itself)
5. **Review changes** when updating hook revisions
6. **Test locally** before committing configuration changes

## Troubleshooting

### Hook Not Running

- Check that file types match hook's `files` pattern
- Verify hook is listed in your `.pre-commit-config.yaml`
- Run `pre-commit run --all-files` to force execution

### Dependency Errors

- Install missing tools using commands provided in hook error messages
- Ensure tools are in your PATH
- For npm tools, consider using `npx` if global installation fails

### Configuration Errors

- Run `racktopia-standards` hook to validate configuration
- Check YAML syntax in `.pre-commit-config.yaml`
- Ensure repository URL and hook IDs are correct

### Network Issues

- racktopia-standards hook requires internet access to check commit freshness via GitHub API
- If offline, hook shows `ℹ️ Could not verify commit recency (network issue?)` and continues
- Freshness checking will resume on next run with internet access
- Hook never fails due to network issues, only due to confirmed outdated revisions

### racktopia-standards Configuration

- Hook limits are configurable by editing variables at the top of the hook file
- Modify `MAX_COMMITS_BEHIND` and `MAX_DAYS_OLD` to adjust freshness requirements
- Adjust `WARNING_COMMIT_THRESHOLD` and `WARNING_DAY_THRESHOLD` for early warnings
- Changes take effect immediately when hook file is updated
