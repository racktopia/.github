#!/bin/bash
# Script: setup-base.sh  
# Description: Base setup script for racktopia projects
# Usage: curl -sSL https://raw.githubusercontent.com/racktopia/.github/main/scripts/setup-base.sh | bash -s <project_type>

set -e  # Exit on error
set -u  # Exit on undefined variable

# Project type from command line argument
PROJECT_TYPE="${1:-}"

if [ -z "$PROJECT_TYPE" ]; then
    echo "Usage: $0 <project_type>"
    echo "Available types: ansible, python, node, generic"
    exit 1
fi

echo "🚀 Setting up $PROJECT_TYPE project..."
echo ""

# Common functions
check_python_version() {
    echo "🐍 Checking Python version..."
    if ! command -v python3 >/dev/null 2>&1; then
        echo "❌ Python 3 is required but not installed"
        exit 1
    fi
    
    python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    echo "✅ Python $python_version found"
    echo ""
}

install_precommit() {
    echo "🔧 Installing pre-commit..."
    if command -v brew >/dev/null 2>&1; then
        brew install pre-commit
    elif command -v port >/dev/null 2>&1; then
        sudo port install pre-commit
    else
        echo "⚠️  Please install pre-commit manually: pip install pre-commit"
        return 1
    fi
    echo "✅ pre-commit installed"
    echo ""
}

setup_precommit_hooks() {
    echo "🪝 Installing pre-commit hooks..."
    if command -v pre-commit >/dev/null 2>&1; then
        if [ -f ".pre-commit-config.yaml" ]; then
            pre-commit install
            echo "✅ Pre-commit hooks installed"
        else
            echo "❌ .pre-commit-config.yaml not found"
        fi
    else
        echo "❌ pre-commit not found but should have been installed earlier"
    fi
    echo ""
}

make_scripts_executable() {
    if [ -d "scripts" ]; then
        echo "🔧 Making scripts executable..."
        chmod +x scripts/*.sh 2>/dev/null || true
        echo "✅ Scripts are now executable"
        echo ""
    fi
}

# Project-specific setup functions
setup_ansible() {
    echo "📦 Installing Ansible dependencies..."
    if command -v brew >/dev/null 2>&1; then
        brew install ansible
    else
        echo "⚠️  Please install Ansible manually"
        return 1
    fi
    
    # Install Ansible Galaxy requirements
    echo "🌌 Installing Ansible Galaxy requirements..."
    if [ -f "requirements.yml" ]; then
        ansible-galaxy install -r requirements.yml
        echo "✅ Galaxy requirements installed"
    else
        echo "⚠️  requirements.yml not found, skipping Galaxy installation"
    fi
    echo ""
}

setup_python() {
    echo "📦 Setting up Python project..."
    if [ -f "requirements.txt" ]; then
        echo "Installing Python requirements..."
        pip install -r requirements.txt
    elif [ -f "pyproject.toml" ]; then
        echo "Installing project with pip..."
        pip install -e .
    fi
    echo ""
}

setup_node() {
    echo "📦 Setting up Node.js project..."
    if [ -f "package.json" ]; then
        echo "Installing Node.js dependencies..."
        npm install
    fi
    echo ""
}

# Main setup flow
main() {
    check_python_version
    install_precommit
    
    case "$PROJECT_TYPE" in
        "ansible")
            setup_ansible
            ;;
        "python")
            setup_python
            ;;
        "node")
            setup_node
            ;;
        "generic")
            echo "ℹ️  Generic setup - no project-specific tools installed"
            ;;
        *)
            echo "❌ Unknown project type: $PROJECT_TYPE"
            echo "Available types: ansible, python, node, generic"
            exit 1
            ;;
    esac
    
    make_scripts_executable
    setup_precommit_hooks
    
    # Success message
    echo "═══════════════════════════════════════"
    echo "✅ $PROJECT_TYPE project setup complete!"
    echo "═══════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "  1. Review and customize configuration files"
    echo "  2. Run validation: ./scripts/validate.sh (if available)"
    echo "  3. Start developing!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]] || [[ -z "${BASH_SOURCE[0]:-}" ]]; then
    main "$@"
fi