# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a development environment setup repository containing automation scripts and configuration files for setting up a Mac-like development environment on Windows and WSL2 Ubuntu. The setup includes modern CLI tools, development environments, and dotfiles.

## Architecture

### Setup Process Flow
1. **Windows Setup** (`win/windows-setup.ps1`): Installs WSL2, Windows applications via winget, and prepares the Windows environment
2. **Ubuntu Setup** (`win/ubuntu-setup.sh`): Installs development tools, configures shell, and applies dotfiles within the WSL2 Ubuntu environment
3. **Configuration Files**: Dotfiles (`.tmux.conf`, `.zshrc.custom`, `.vimrc`) provide consistent development environment configuration

### Key Components

- **Windows PowerShell Script**: Automates WSL2 installation and Windows application setup via winget
- **Ubuntu Bash Script**: Comprehensive development environment setup including:
  - Modern CLI tools (eza, ripgrep, fd, fzf, bat)
  - Development languages and tools (Node.js, Rust, Terraform)
  - Shell environment (zsh, Oh My Zsh)
  - Terminal multiplexer (tmux with plugins)
- **Configuration Files**: Pre-configured dotfiles optimized for development workflow

## Setup Commands

### Windows (PowerShell as Administrator)
```powershell
# Run the Windows setup script
./win/windows-setup.ps1
```

### Ubuntu (WSL2)
```bash
# Copy files from Windows to Ubuntu
cp /mnt/c/path/to/setup/files/* .
chmod +x ubuntu-setup.sh

# Run the Ubuntu setup script
./ubuntu-setup.sh
```

## Configuration Details

### Shell Configuration
- **Default Shell**: zsh with Oh My Zsh
- **Theme**: robbyrussell
- **Key Aliases**: Modern replacements for traditional commands (ls→eza, cat→bat, find→fd, grep→rg)

### Tmux Configuration
- **Prefix Key**: Ctrl+a (instead of default Ctrl+b)
- **Mouse Support**: Enabled for modern terminal interaction
- **Plugin Manager**: TPM with essential plugins for productivity

### Vim Configuration
- **Modern Features**: Relative line numbers, syntax highlighting, smart indentation
- **Key Mappings**: Convenient shortcuts for common operations
- **File Handling**: Automatic backup and undo history

## Verification

The Ubuntu setup script includes comprehensive verification steps that check:
- Installation of all required packages
- Creation and proper formatting of dotfiles
- Plugin manager installations
- Shell configuration linking

## Development Workflow

This setup creates a consistent development environment with:
- Enhanced terminal experience (tmux + modern CLI tools)
- Optimized shell with productivity aliases
- Version control integration (Git with shortcuts)
- Infrastructure tooling (Terraform)
- Modern text editing capabilities